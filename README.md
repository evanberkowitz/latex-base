# latex-base
An example of my preferred use of LaTeX + git.

For more information, clone and `make`.  `master.pdf` explains what's going on here.

# A template repository for LaTeX documents

GitHub introduced [repository templates](https://github.blog/2019-06-06-generate-new-repositories-with-repository-templates/), which is exactly the use case of this repo.  If you look at [the main repository page](https://github.com/evanberkowitz/latex-base) next to the familiar clone or download button you should see a bright green "Use this template" button.  Clicking it will allow you to start your own fresh repo (not a fork) with a fresh name in any organization you have repo creation privileges in.

You can also navigate to [the /generate endpoint of this repo](https://github.com/evanberkowitz/latex-base/generate) to achieve the same effect.

# A base for other documents

*You can still use this method, but consider using this repository as a template repository instead, as explained above.*

Rather than forking this repository, it probably makes sense to use it as a base to import.  You can [import a repo on GitHub](https://github.com/new/import) and give it an independent history without keeping it tied to the original repo forever.

# Dependencies

Mandatory:

 - `git`
 - `make`
 - A LaTeX installation.

Optional:

 - [`watchman`](https://github.com/facebook/watchman/), for continuous TeX recompilation.
 - [`git latexdiff`](https://gitlab.com/git-latexdiff/git-latexdiff), for producing PDFs with diff highlighting.
