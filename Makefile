LATEXMKRC=$(realpath .latexmkrc)

LATEXMK_OPTIONS=-synctex=1 $\
				-interaction=nonstopmode $\
				-recorder $\
				-file-line-error $\
				-shell-escape $\
				-halt-on-error $\
				-r $(LATEXMKRC)

CHKTEX_OPTIONS=--localrc ./.chktexrc $\
			   --headererr $\
			   --inputfiles $\
			   --format=1 $\
			   --verbosity=2

LATEXINDENT_OPTIONS=--local=indentconfig.yaml $\
					--overwrite


all: updatecls
	latexmk $(LATEXMK_OPTIONS) -pdf main.tex

clean:
	for file in $(shell find . -name "*.tex"); do \
		DIR=`dirname $$file`; \
		latexmk -C -outdir=$$DIR $$file; \
	done

cleanaux:
	for file in $(shell find . -name "*.tex"); do \
		DIR=`dirname $$file`; \
		latexmk -c -outdir=$$DIR $$file; \
	done

# remove backup files that generated by latexindent.pl
cleanbak:
	rm -f $(shell find . -regex ".*\.\(bak\d*\|log\)$$")

# lint all tex files
lint:
	chktex $(CHKTEX_OPTIONS) $(shell find . -name "*.tex")

# format all tex, cls, sty files
# all files and directories should not contain any white space in their names
format:
	for file in $(shell find . -regex ".*\.\(tex\|cls\|sty\)\$$"); do \
		echo "\nFormatting $$file ...\n"; \
		latexindent $(LATEXINDENT_OPTIONS) $$file; \
	done

updatecls:
	if [ ! -z $(shell find . -maxdepth 1 -name "*.cls") ]; then \
		mkdir -p $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class; \
		cp *.cls $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class; \
	fi

%.pdf: %.tex updatecls
	latexmk $(LATEXMK_OPTIONS) -pdf -pvc -outdir=$(shell dirname $<) $(shell basename $<)

%.dvi: %.tex updatecls
	latexmk $(LATEXMK_OPTIONS) -dvi -pvc -outdir=$(shell dirname $<) $(shell basename $<)

%.ps: %.tex updatecls
	latexmk $(LATEXMK_OPTIONS) -ps -pvc -outdir=$(shell dirname $<) $(shell basename $<)

%.pdf.o: %.tex updatecls
	latexmk $(LATEXMK_OPTIONS) -pdf -outdir=$(shell dirname $<) $(shell basename $<)

%.dvi.o: %.tex updatecls
	latexmk $(LATEXMK_OPTIONS) -dvi -outdir=$(shell dirname $<) $(shell basename $<)

%.ps.o: %.tex updatecls
	latexmk $(LATEXMK_OPTIONS) -ps -outdir=$(shell dirname $<) $(shell basename $<)

# lint specific TeX file
%.lint: %.tex
	chktex $(CHKTEX_OPTIONS) $<

# format specific TeX file
%.format: %.tex
	latexindent $(LATEXINDENT_OPTIONS) $<
