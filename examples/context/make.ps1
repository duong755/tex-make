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
        context --synctex --nonstopmode --pdftex ./main.tex
    }
    "all" {
        $texmfhome = kpsewhich -var-value=TEXMFHOME
        if (!(Test-Path "$texmfhome/tex/latex/local/class" -PathType Container)) {
            New-Item -Path "$texmfhome/tex/latex/local/class" -ItemType Directory
        }
        $(Get-ChildItem -Recurse -File -Include "*.cls") | ForEach-Object -Process {
            Copy-Item -Force $_.FullName "$texmfhome/tex/latex/local/class"
        }
        context --synctex --nonstopmode --pdftex ./main.tex
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

            switch -Regex ($Target) {
                "\.pdf$" {
                    context --synctex --nonstopmode --pdftex $texFileAbsPath
                }
                "\.format$" {
                    latexindent --local=$indentconfig `
                        --overwrite `
                        --silent `
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
