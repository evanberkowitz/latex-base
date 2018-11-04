TEX=pdflatex -halt-on-error -shell-escape
BIB=bibtex

MASTER=master
TARGET?=$(MASTER)
SECTIONS = $(shell ls -1 section/ | sed -e 's/^/section\//g')

ifndef VERBOSE
	REDIRECT=1>/dev/null 2>/dev/null
endif

all: $(MASTER).pdf

%.pdf: $(SECTIONS) macros.tex %.tex
	@echo $@
	$(TEX) -jobname=$* $*.tex $(REDIRECT)
	-$(BIB) $* $(REDIRECT)
	$(TEX) -jobname=$* $*.tex $(REDIRECT)
	$(TEX) -jobname=$* $*.tex $(REDIRECT)
	make tidy

.PHONY: git-hooks
git-hooks:
	for h in hooks/*; do ln -f -s "../../$$h" ".git/$$h"; done

.PHONY: tidy
tidy:
	$(RM) git_information.aux section/*.aux
	$(RM) $(TARGET).{out,log,aux,synctex.gz,bbl,blg,toc,fls,fdb_latexmk}

.PHONY: clean
clean: tidy
	$(RM) $(TARGET)Notes.bib
	$(RM) $(TARGET).pdf

.PHONY: watch
watch: $(TARGET).pdf
	watchman-make -p '**/*.tex' '*/*.tex' '*.tex' '*.bib' -t $(TARGET).pdf 