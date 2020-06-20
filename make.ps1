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

switch ($Target) {
    "" {
        latexmk -synctex=1 `
            -interaction=nonstopmode `
            -recorder `
            -file-line-error `
            -shell-escape `
            -halt-on-error `
            -pdf `
            ./main.tex
    }
    "all" {
        latexmk -synctex=1 `
            -interaction=nonstopmode `
            -recorder `
            -file-line-error `
            -shell-escape `
            -halt-on-error `
            -pdf `
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
    "chktex" {
        $files = $(Get-ChildItem -Recurse -File)
        $files | Where-Object -FilterScript { $_.Extension -eq ".tex" } | ForEach-Object -Process {
            chktex --localrc "./.chktexrc" --headererr --inputfiles --format=1 --verbosity=2 $_.FullName
        }
    }
    "formatall" {
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
        Copy-Item -Force *.cls "$texmfhome/tex/latex/local/class"
    }
    Default {
        $filePattern = [System.Text.RegularExpressions.Regex]"\.(pdf(\.o)?|dvi(\.o)?|ps(\.o)?|format)$"

        $texFile = $filePattern.Replace($Target, ".tex")

        if ((Test-Path $texFile -PathType Leaf) -And ($filePattern.IsMatch($Target))) {
            $absPath = Resolve-Path $texFile
            $outdir = Split-Path $absPath
            Write-Output $outdir
            switch -Regex ($Target) {
                "\.pdf$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -pdf `
                        -pvc `
                        -outdir="$outdir" `
                        $texFile
                }
                "\.dvi$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -dvi `
                        -pvc `
                        -outdir="$outdir" `
                        $texFile
                }
                "\.ps$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -ps `
                        -pvc `
                        -outdir="$outdir" `
                        $texFile
                }
                "\.pdf\.o$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -pdf `
                        -outdir="$outdir" `
                        $texFile
                }
                "\.dvi\.o$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -dvi `
                        -outdir="$outdir" `
                        $texFile
                }
                "\.ps\.o$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -ps `
                        -outdir="$outdir" `
                        $texFile
                }
                "\.format$" {
                    latexindent --local=indentconfig.yaml `
                        --overwrite `
                        $texFile
                }
            }
        }
        else {
            Write-Output "make: *** No rule to make target '$Target'.  Stop."
        }

    }
}
