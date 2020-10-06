TEX=pdflatex -halt-on-error -interaction=nonstopmode
BIB=bibtex

REPO=git
OLD?=$(shell git rev-parse --short HEAD)
NEW?=--
ROOT:=$(shell pwd)

MASTER=master
TARGET?=$(MASTER)
SECTIONS = $(shell find section -type f)
BIBS = $(find . -name '*.bib')


ifndef VERBOSE
	REDIRECT=1>/dev/null 2>/dev/null
endif

ifndef FINAL
	OPTIONS?=$(shell ./repo/$(REPO).sh $(OLD) $(NEW))
endif

all: $(TARGET).pdf

ifndef DIFF
%.pdf: .git/HEAD .git/index $(SECTIONS) $(BIBS) macros.tex %.tex
	DIFF=1 SHORTCIRCUIT=1 $(MAKE) $*.pdf
else
ifdef SHORTCIRCUIT
%.pdf: .git/HEAD .git/index $(SECTIONS) $(BIBS) macros.tex %.tex
	@echo $@
	$(TEX) -jobname=$* "$(OPTIONS)\input{$*}" $(REDIRECT)
	-$(BIB) $* $(REDIRECT)
	$(TEX) -jobname=$* "$(OPTIONS)\input{$*}" $(REDIRECT)
	$(TEX) -jobname=$* "$(OPTIONS)\input{$*}" $(REDIRECT)
	$(MAKE) tidy
else
%.pdf: $(SECTIONS) $(BIBS) macros.tex %.tex
	SHORTCIRCUIT=1 OPTIONS="$(OPTIONS)" git latexdiff --whole-tree --main $(TARGET).tex --prepare "rm -rf repo; ln -s $(ROOT)/repo; ln -s $(ROOT)/.git" -o $(TARGET).pdf $(OLD) $(NEW)
endif
endif

.PHONY: tidy
tidy:
	$(RM) section/*.aux
	$(RM) $(TARGET)Notes.bib
	$(RM) $(TARGET).{out,log,aux,synctex.gz,blg,toc,fls,fdb_latexmk}

.PHONY: clean
clean: tidy
	$(RM) $(TARGET).bbl
	$(RM) $(TARGET).pdf

.PHONY: watch
watch: $(TARGET).pdf
	when-changed -s -1 -r . make
