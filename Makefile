LATEX_OPTIONS = -synctex=1 -interaction=nonstopmode -recorder -file-line-error -shell-escape -halt-on-error -pdf

CHKTEX_OPTIONS = --localrc ./.chktexrc --headererr --inputfiles --format=1 --verbosity=2

all:
	latexmk $(LATEX_OPTIONS) main.tex
clean:
	git clean -fdX
chktex:
	chktex $(CHKTEX_OPTIONS) $(shell find . -name "*.tex")
usecls:
	mkdir -p $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class
	cp ./*.cls $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class
%:
	latexmk $(LATEX_OPTIONS) -output-directory=$(MAKECMDGOALS) $(MAKECMDGOALS)/$(MAKECMDGOALS).tex
