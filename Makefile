LATEXMK_OPTIONS := -synctex=1 $\
				   -interaction=nonstopmode $\
				   -recorder $\
				   -file-line-error $\
				   -shell-escape $\
				   -halt-on-error $\
				   -pdf
CHKTEX_OPTIONS := --localrc ./.chktexrc $\
				  --headererr $\
                  --inputfiles $\
				  --format=1 $\
				  --verbosity=2
LATEXINDENT_OPTIONS := --local=indentconfig.yaml $\
					   --overwrite

all:
	latexmk $(LATEXMK_OPTIONS) main.tex

clean:
	git clean -f -d -X

chktex:
	chktex $(CHKTEX_OPTIONS) $(shell find . -name "*.tex")

# all files and directories should not contain any white space in their names
formatall:
	for file in $(shell find . -regex ".*\.\(tex\|cls\|sty\)\$$"); do \
        echo "\n\n"; \
        echo "Formatting $$file ...\n"; \
		latexindent $(LATEXINDENT_OPTIONS) $$file; \
	done

updatecls:
	mkdir -p $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class
	cp *.cls $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class

# to build chapter0, run make chapter0 -B
# to build section1 of chapter1, run make chapter1/section1 -B
# you might need to run make clean first
%:
	latexmk $(LATEXMK_OPTIONS) -outdir=$(MAKECMDGOALS) $(shell find $(MAKECMDGOALS) -maxdepth 1 -regex ".*\.tex\$$" -not -type d)
