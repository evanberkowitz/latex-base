TEX=pdflatex -halt-on-error
BIB=bibtex

MASTER=master
TARGET?=$(MASTER)
SECTIONS = $(shell ls -1 section/ | sed -e 's/^/section\//g')
BIBS = $(find . -name '*.bib')

ifndef VERBOSE
	REDIRECT=1>/dev/null 2>/dev/null
endif

ifdef DRAFT
	OPTIONS= "$(shell ./git_information.sh)\input{$*.tex}"
else
	OPTIONS= '\input{$*.tex}'
endif

all: $(MASTER).pdf

%.pdf: $(SECTIONS) $(BIBS) macros.tex %.tex
	@echo $@
	$(TEX) -jobname=$* $(OPTIONS) $(REDIRECT)
	-$(BIB) $* $(REDIRECT)
	$(TEX) -jobname=$* $(OPTIONS) $(REDIRECT)
	$(TEX) -jobname=$* $(OPTIONS) $(REDIRECT)
	make tidy
	
.PHONY: git-hooks
git-hooks:
	for h in hooks/*; do ln -f -s "../../$$h" ".git/$$h"; done

.PHONY: tidy
tidy:
	$(RM) section/*.aux
	$(RM) $(TARGET).{out,log,aux,synctex.gz,bbl,blg,toc,fls,fdb_latexmk}

.PHONY: clean
clean: tidy
	$(RM) $(TARGET)Notes.bib
	$(RM) $(TARGET).pdf

.PHONY: watch
watch: $(TARGET).pdf
	watchman-make -p '**/*.tex' '*/*.tex' '*.tex' '*.bib' -t $(TARGET).pdf 