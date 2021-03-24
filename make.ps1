[CmdletBinding()]
param (
    [Parameter(Mandatory = $false,
        ValueFromPipeline = $true,
        ValueFromRemainingArguments = $true,
        ParameterSetName = "Target",
        HelpMessage = "Target name")]
    [System.String]
    $Target
)

$latexmkrc = Resolve-Path ./latexmkrc
$chktexrc = Resolve-Path ./chktexrc
$indentconfig = Resolve-Path ./indentconfig.yaml

switch ($Target) {
    "" {
        $texmfhome = kpsewhich -var-value=TEXMFHOME
        if (!(Test-Path "$texmfhome/tex/latex/local/class" -PathType Container)) {
            New-Item -Path "$texmfhome/tex/latex/local/class" -ItemType Directory
        }
        $(Get-ChildItem -Recurse -File -Include "*.cls") | ForEach-Object -Process {
            Copy-Item -Force $_.FullName "$texmfhome/tex/latex/local/class"
        }
        latexmk -f -synctex=1 `
            -interaction=nonstopmode `
            -recorder `
            -file-line-error `
            -shell-escape `
            -halt-on-error `
            -pdf `
            -r $latexmkrc `
            ./main.tex
    }
    "all" {
        $texmfhome = kpsewhich -var-value=TEXMFHOME
        if (!(Test-Path "$texmfhome/tex/latex/local/class" -PathType Container)) {
            New-Item -Path "$texmfhome/tex/latex/local/class" -ItemType Directory
        }
        $(Get-ChildItem -Recurse -File -Include "*.cls") | ForEach-Object -Process {
            Copy-Item -Force $_.FullName "$texmfhome/tex/latex/local/class"
        }
        latexmk -f -synctex=1 `
            -interaction=nonstopmode `
            -recorder `
            -file-line-error `
            -shell-escape `
            -halt-on-error `
            -pdf `
            -r $latexmkrc `
            ./main.tex
    }
    "clean" {
        $files = $(Get-ChildItem -Recurse -File)
        $files | Where-Object -FilterScript { $_.Extension -eq ".tex" } | ForEach-Object -Process {
            latexmk -C -outdir="$($_.DirectoryName)" $_.FullName
        }
    }
    "cleanaux" {
        $files = $(Get-ChildItem -Recurse -File)
        $files | Where-Object -FilterScript { $_.Extension -eq ".tex" } | ForEach-Object -Process {
            latexmk -c -outdir="$($_.DirectoryName)" $_.FullName
        }
    }
    "cleanbak" {
        $files = $(Get-ChildItem -Recurse -File)
        $files | Where-Object -FilterScript { $_.Extension -match "\.(bak|log)$" } | ForEach-Object -Process {
            Remove-Item -Force $_.FullName
        }
    }
    "lint" {
        $files = $(Get-ChildItem -Recurse -File)
        $files | Where-Object -FilterScript { $_.Extension -eq ".tex" } | ForEach-Object -Process {
            chktex --localrc "./.chktexrc" --headererr --inputfiles --format=1 --verbosity=2 $_.FullName
        }
    }
    "format" {
        $files = $(Get-ChildItem -Recurse -File)
        $files | Where-Object -FilterScript { $_.Extension -match "\.(tex|cls|sty)$" } | ForEach-Object -Process {
            latexindent --local="./indentconfig.yaml" --overwrite $_.FullName
        }
    }
    "updatecls" {
        $texmfhome = kpsewhich -var-value=TEXMFHOME
        if (!(Test-Path "$texmfhome/tex/latex/local/class" -PathType Container)) {
            New-Item -Path "$texmfhome/tex/latex/local/class" -ItemType Directory
        }
        $(Get-ChildItem -Recurse -File -Include "*.cls") | ForEach-Object -Process {
            Copy-Item -Force $_.FullName "$texmfhome/tex/latex/local/class"
        }
    }
    Default {
        $filePattern = [System.Text.RegularExpressions.Regex]"\.(pdf(\.o)?|dvi(\.o)?|ps(\.o)?|format|lint)$"

        $texFile = $filePattern.Replace($Target, ".tex")

        if ((Test-Path $texFile -PathType Leaf) -And ($filePattern.IsMatch($Target))) {
            $texFileAbsPath = Resolve-Path $texFile
            $outdir = Split-Path $texFileAbsPath

            $texmfhome = kpsewhich -var-value=TEXMFHOME
            if (!(Test-Path "$texmfhome/tex/latex/local/class" -PathType Container)) {
                New-Item -Path "$texmfhome/tex/latex/local/class" -ItemType Directory
            }
            $(Get-ChildItem -Recurse -File -Include "*.cls") | ForEach-Object -Process {
                Copy-Item -Force $_.FullName "$texmfhome/tex/latex/local/class"
            }

            $files = $(Get-ChildItem -Recurse -File)
            $files | Where-Object -FilterScript { $_.Extension -eq ".tex" } | ForEach-Object -Process {
                latexmk -C -outdir="$($_.DirectoryName)" $_.FullName
            }

            switch -Regex ($Target) {
                "^(asy/)" {
                    $dirName = [System.Text.RegularExpressions.Regex]"^(asy/)".Replace($Target, "")
                    $asyFiles = $(Get-ChildItem -Recurse -File -Path $dirName | Where-Object -FilterScript { $_.Extension -eq ".asy" })
                    $asyFiles | ForEach-Object -Process {
                        asy $_.Name -cd $_.DirectoryName
                    }
                }
                "\.pdf$" {
                    latexmk -f -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -pdf `
                        -pvc `
                        -r $latexmkrc `
                        -outdir="$outdir"
                    $texFileAbsPath
                }
                "\.dvi$" {
                    latexmk -f -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -dvi `
                        -pvc `
                        -r $latexmkrc `
                        -outdir="$outdir"
                    $texFileAbsPath
                }
                "\.ps$" {
                    latexmk -f -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -ps `
                        -pvc `
                        -r $latexmkrc `
                        -outdir="$outdir"
                    $texFileAbsPath
                }
                "\.pdf\.o$" {
                    latexmk -f -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -pdf `
                        -outdir="$outdir" `
                        -r $latexmkrc `
                        -outdir="$outdir"
                    $texFileAbsPath
                }
                "\.dvi\.o$" {
                    latexmk -f -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -dvi `
                        -r $latexmkrc `
                        -outdir="$outdir"
                    $texFileAbsPath
                }
                "\.ps\.o$" {
                    latexmk -f -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -ps `
                        -r $latexmkrc `
                        -outdir="$outdir"
                    $texFileAbsPath
                }
                "\.format$" {
                    latexindent --local=$indentconfig `
                        --overwrite `
                        $texFileAbsPath
                }
                "\.lint$" {
                    chktex --localrc $chktexrc `
                        --headererr `
                        --inputfiles `
                        --format=1 `
                        --verbosity=2 `
                        $texFileAbsPath
                }
                Default {
                    Write-Output "make: *** No rule to make target '$Target'.  Stop."
                }
            }
        }
        else {
            Write-Output "make: *** No rule to make target '$Target'.  Stop."
        }
    }
}
