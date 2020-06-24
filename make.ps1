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

$latexmkrc = Resolve-Path ./.latexmkrc
$chktexrc = Resolve-Path ./.chktexrc
$indentconfig = Resolve-Path ./indentconfig.yaml
$rootDir = (Get-Location).Path

switch ($Target) {
    "" {
        latexmk -synctex=1 `
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
        latexmk -synctex=1 `
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
        Copy-Item -Force *.cls "$texmfhome/tex/latex/local/class"
    }
    Default {
        $filePattern = [System.Text.RegularExpressions.Regex]"\.(pdf(\.o)?|dvi(\.o)?|ps(\.o)?|format|lint)$"

        $texFile = $filePattern.Replace($Target, ".tex")

        if ((Test-Path $texFile -PathType Leaf) -And ($filePattern.IsMatch($Target))) {
            $texFileAbsPath = Resolve-Path $texFile
            $outdir = Split-Path $texFileAbsPath

            Set-Location $outdir

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
                        -r $latexmkrc `
                        $texFileAbsPath
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
                        -r $latexmkrc `
                        $texFileAbsPath
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
                        -r $latexmkrc `
                        $texFileAbsPath
                }
                "\.pdf\.o$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -pdf `
                        -r $latexmkrc `
                        $texFileAbsPath
                }
                "\.dvi\.o$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -dvi `
                        -r $latexmkrc `
                        $texFileAbsPath
                }
                "\.ps\.o$" {
                    latexmk -synctex=1 `
                        -interaction=nonstopmode `
                        -recorder `
                        -file-line-error `
                        -shell-escape `
                        -halt-on-error `
                        -ps `
                        -r $latexmkrc `
                        $texFileAbsPath
                }
                "\.format$" {
                    Set-Location $rootDir
                    latexindent --local=$indentconfig `
                        --overwrite `
                        $texFileAbsPath
                }
                "\.lint$" {
                    Set-Location $rootDir
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
            Set-Location $rootDir
        }
        else {
            Write-Output "make: *** No rule to make target '$Target'.  Stop."
        }

    }
}
