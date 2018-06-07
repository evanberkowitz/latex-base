TEX=pdflatex -halt-on-error
BIB=bibtex
GIT_STATUS=git_information.tex

MASTER=master
SECTIONS = $(shell ls -1 section/ | sed -e 's/^/section\//g')

all: $(MASTER).pdf

master.pdf: $(SECTIONS) macros.tex master.tex
	make $(GIT_STATUS)
	$(TEX) master.tex
	$(BIB) master
	$(TEX) master.tex
	$(TEX) master.tex
	make clean_temporary_files

.PHONY: $(GIT_STATUS)

$(GIT_STATUS): 
	./git_information.sh > $(GIT_STATUS)

.PHONY: git-hooks
git-hooks:
	for h in hooks/*; do ln -f -s "../../$$h" ".git/$$h"; done

.PHONY: clean_temporary_files
clean_temporary_files:
	$(RM) git_information.aux section/*.aux
	$(RM) $(MASTER).{out,log,aux,synctex.gz,bbl,blg,toc,fls,fdb_latexmk}

.PHONY: clean
clean: clean_temporary_files
	$(RM) $(GIT_STATUS)
	$(RM) $(MASTER).pdf

.PHONY: watch
watch:
	watchman-make -p '**/*.tex' '*/*.tex' '*.tex' '*.bib' -t master.pdf