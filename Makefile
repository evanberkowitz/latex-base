TEX=pdflatex -halt-on-error
BIB=bibtex
GIT_STATUS=git_information.tex

DRAFT=draft
MASTER=master
SECTIONS = $(shell ls -1 section/ | sed -e 's/^/section\//g')

ifndef VERBOSE
	REDIRECT=1>/dev/null 2>/dev/null
endif

all: $(MASTER).pdf

$(MASTER).pdf: $(SECTIONS) macros.tex $(MASTER).tex
	@echo $@
	echo "" > $(GIT_STATUS) $(REDIRECT)
	$(TEX) $(MASTER).tex $(REDIRECT)
	$(BIB) master $(REDIRECT)
	$(TEX) $(MASTER).tex $(REDIRECT)
	$(TEX) $(MASTER).tex $(REDIRECT)
	make tidy

$(DRAFT).pdf: $(SECTIONS) $(MASTER).tex
	@echo $@
	make $(GIT_STATUS)
	$(TEX) -jobname=$(DRAFT) $(MASTER).tex $(REDIRECT)
	$(BIB) $(DRAFT) $(REDIRECT)
	$(TEX) -jobname=$(DRAFT) $(MASTER).tex $(REDIRECT)
	$(TEX) -jobname=$(DRAFT) $(MASTER).tex $(REDIRECT)
	make tidy

.PHONY: $(GIT_STATUS)

$(GIT_STATUS): 
	./git_information.sh > $(GIT_STATUS)

.PHONY: git-hooks
git-hooks:
	for h in hooks/*; do ln -f -s "../../$$h" ".git/$$h"; done

.PHONY: tidy
tidy:
	$(RM) git_information.aux section/*.aux
	$(RM) {$(MASTER),$(DRAFT)}.{out,log,aux,synctex.gz,bbl,blg,toc,fls,fdb_latexmk}

.PHONY: clean
clean: tidy
	$(RM) $(GIT_STATUS)
	$(RM) {$(MASTER),$(DRAFT)}Notes.bib
	$(RM) {$(MASTER),$(DRAFT)}.pdf

.PHONY: watch
watch: $(DRAFT).pdf
	watchman-make -p '**/*.tex' '*/*.tex' '*.tex' '*.bib' -t $(DRAFT).pdf