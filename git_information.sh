#!/usr/bin/env bash

result="`git status --porcelain 2>/dev/null| wc -l | tr -d [:blank:]`"' files different from commit '"`git rev-parse --short HEAD`"' from '"`git log -1 --format=%ad --date=iso`"

# Correct "1 files" pluralization madness.
if [[ "${result:0:2}" == "1 " ]]; then
    result=${result/1 files/1 file}
fi

# Turn red if there are dirty files.
if [[ ! "${result:0:1}" == "0" ]]; then
    result="{\color{Red}${result}}"
else
    result="{\color{Green}${result}}"
fi

result="\newcommand{\gitmarginsetup}{
    \usepackage[dvipsnames]{xcolor}
    \usepackage[ angle=90, color=black, opacity=1, scale=2, ]{background} 
    \SetBgPosition{current page.west} 
    \SetBgVshift{-4.5mm} 
    \backgroundsetup{contents={${result}}}
}"

echo "${result}"