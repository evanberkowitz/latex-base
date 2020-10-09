# latex-base
An example of my preferred use of LaTeX + git.

For more information, clone and `make`.  `master.pdf` explains what's going on here.

# A template repository for LaTeX documents

GitHub introduced [repository templates](https://github.blog/2019-06-06-generate-new-repositories-with-repository-templates/), which is exactly the use case of this repo.  If you look at [the main repository page](https://github.com/evanberkowitz/latex-base) next to the familiar clone or download button you should see a bright green "Use this template" button.  Clicking it will allow you to start your own fresh repo (not a fork) with a fresh name in any organization you have repo creation privileges in.

You can also navigate to [the /generate endpoint of this repo](https://github.com/evanberkowitz/latex-base/generate) to achieve the same effect.

# Continuous Integration with GitHub Actions

GitHub allows you to trigger actions on particular changes to the repository.  I have used a [latex-action](https://github.com/dante-ev/latex-action) to attempt to compile each pushed update to a PDF.  In addition, on a pull-request, [`git-latexdiff`](https://gitlab.com/git-latexdiff/git-latexdiff) is used to compile a PDF that highlights the differences between the two branches to be reconciled.

# Dependencies

Mandatory:

 - `git`
 - `make`
 - A LaTeX installation, including the [REVTeX](https://en.wikipedia.org/wiki/REVTeX) macros.

Optional:

 - [`when-changed`](https://github.com/joh/when-changed), for continuous TeX recompilation.
 - [`git latexdiff`](https://gitlab.com/git-latexdiff/git-latexdiff), for producing PDFs with diff highlighting.
