The hooks
    post-merge
and
    pre-commit
hooks from the latex-base repo.

The pre-commit hook prevents the user from `git commit`ting a commit that doesn't compile, which it tests for by stashing all files that don't belong to the commit and trying to `make master.pdf`.  The output of that `make` is created in the `.git-pre-commit-hook.log` in the root directory of this repository, so that the user can see the LaTeX in the event the PDF doesn't compile.

The `post-merge` hook tries to compile the latest PDF, also using `make master.pdf` after the repository has been updated.
It is much less sophisticated than the pre-commit hook, because (under the assumption the pre-commit hook is working) the committed state of the repo should always compile.
