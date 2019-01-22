TEX=pdflatex -halt-on-error
BIB=bibtex

REPO=git
OLD?=$(shell git rev-parse --short HEAD)
NEW?=--
ROOT:=$(shell pwd)

MASTER=master
TARGET?=$(MASTER)
SECTIONS = $(shell ls -1 section/ | sed -e 's/^/section\//g')
BIBS = $(find . -name '*.bib')


ifndef VERBOSE
	REDIRECT=1>/dev/null 2>/dev/null
endif

ifdef DRAFT
	OPTIONS:=$(shell ./repo/$(REPO).sh $(OLD) $(NEW))
endif

all: $(MASTER).pdf

%.pdf: $(SECTIONS) $(BIBS) macros.tex %.tex
	@echo $@
	$(TEX) -jobname=$* "$(OPTIONS)\input{$*}" $(REDIRECT)
	-$(BIB) $* $(REDIRECT)
	$(TEX) -jobname=$* "$(OPTIONS)\input{$*}" $(REDIRECT)
	$(TEX) -jobname=$* "$(OPTIONS)\input{$*}" $(REDIRECT)
	make tidy

.PHONY: diff
diff:
	git latexdiff --whole-tree --main $(TARGET).tex --prepare "rm -rf repo; ln -s $(ROOT)/repo" -o $(TARGET).pdf $(OLD) $(NEW)

.PHONY: git-hooks
git-hooks:
	for h in hooks/*; do ln -f -s "../../$$h" ".git/$$h"; done

.PHONY: tidy
tidy:
	$(RM) section/*.aux
	$(RM) $(TARGET).{out,log,aux,synctex.gz,blg,toc,fls,fdb_latexmk}

.PHONY: clean
clean: tidy
	$(RM) $(TARGET).bbl
	$(RM) $(TARGET)Notes.bib
	$(RM) $(TARGET).pdf

.PHONY: watch
watch: $(TARGET).pdf
	watchman-make -p '**/*.tex' '*/*.tex' '*.tex' '*.bib' -t $(TARGET).pdf 