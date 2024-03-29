LUALATEX_OPTIONS=--synctex=1 $\
				--interaction=nonstopmode $\
				--recorder $\
				--file-line-error $\
				--shell-escape $\
				--halt-on-error $\

CHKTEX_OPTIONS=--localrc ./chktexrc $\
			   --headererr $\
			   --inputfiles $\
			   --format=1 $\
			   --verbosity=2

LATEXINDENT_OPTIONS=--local=indentconfig.yaml $\
					--overwrite


all: updatecls
	@lualatex $(LUALATEX_OPTIONS) --output-format=pdf main.tex

# remove backup files that generated by latexindent.pl
cleanbak:
	@find . -type f -regextype grep -regex ".*\.\(bak\d*\|log\)$$" -exec rm -f {} \;

# lint all tex files
lint:
	@find . -name "*.tex" -exec chktex $(CHKTEX_OPTIONS) {} \;

# format all tex, cls, sty files
# all files and directories should not contain any white space in their names
format:
	@find . -type f -regex ".*\.\(tex\|cls\|sty\)$$" -exec latexindent $(LATEXINDENT_OPTIONS) {} \;

updatecls:
	@mkdir -p $(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class; \
	CLSPATH=$(shell kpsewhich -var-value=TEXMFHOME)/tex/latex/local/class;  \
	find . -name "*.cls" -exec cp {} $$CLSPATH \; \

%.pdf: %.tex updatecls
	@lualatex $(LUALATEX_OPTIONS) --output-format=pdf --output-directory=$(shell dirname $<) $(shell basename $<)

%.dvi: %.tex updatecls
	@lualatex $(LUALATEX_OPTIONS) --output-format=dvi --output-directory=$(shell dirname $<) $(shell basename $<)

# lint specific TeX file
%.lint: %.tex
	@chktex $(CHKTEX_OPTIONS) $<

# format specific TeX file
%.format: %.tex
	@latexindent $(LATEXINDENT_OPTIONS) $<
