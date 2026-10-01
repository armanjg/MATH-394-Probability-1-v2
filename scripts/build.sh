#!/bin/bash

set -e

rm -rf docs
mkdir -p docs chapter_build docs/Figures docs/Annotated

# Seed small prebuilt HTML/CSS fallbacks, then overwrite what can be regenerated.
cp -R site/static/. docs/ 2>/dev/null || true
cp site/index.html docs/index.html
cp assets/annotated/*.pdf docs/Annotated/
cp assets/figures/* docs/Figures/


 


latexmk -pdf -f \
  -interaction=nonstopmode \
  -output-directory=docs \
  source/syllabus.tex
(cd source && make4ht -u -d ../docs syllabus.tex "mathjax") || { echo "WARNING: HTML conversion failed; keeping existing published HTML if available." >&2; }



for dist in distributions-v1 distributions-v2; do
  latexmk -pdf -f \
    -interaction=nonstopmode \
    -output-directory=docs \
    "source/handouts/${dist}.tex"

  (cd source/handouts && make4ht -u -d ../../docs "${dist}.tex" "mathjax") || { echo "WARNING: HTML conversion failed; keeping existing published HTML if available." >&2; }
done




latexmk -pdf -f \
  -interaction=nonstopmode \
  -output-directory=docs \
  source/handouts/normal-table.tex
(cd source/handouts && make4ht -u -d ../../docs normal-table.tex "mathjax") || { echo "WARNING: HTML conversion failed; keeping existing published HTML if available." >&2; }



# MINI-PROJECT INSTRUCTIONS
latexmk -pdf -f \
  -interaction=nonstopmode \
  -output-directory=docs \
  source/handouts/project.tex

(cd source/handouts && make4ht -u -d ../../docs project.tex "mathjax") || { echo "WARNING: HTML conversion failed; keeping existing published HTML if available." >&2; }



# Full PDF
latexmk -pdf -f \
  -interaction=nonstopmode \
  -output-directory=docs \
  source/lectures/main.tex

 
# Individual chapter PDFs
for chapter in source/lectures/chapters/*.tex; do
  name=$(basename "$chapter" .tex)

  case "$name" in
    chapter1a_sample_spaces_events)
      title="Chapter 1A: Why Probability? Sample Spaces and Events"
      ;;
    chapter1b_naive_probability)
      title="Chapter 1B: Naive Probability"
      ;;
    chapter1cd_counting)
      title="Chapter 1C--1D: Counting, Multiplication Rule, and Binomial Coefficients"
      ;;
    chapter1f_axiomatic_probability)
      title="Chapter 1F: Axiomatic Probability and the Addition Rule"
      ;;
    chapter2_conditional_probability)
      title="Chapter 2: Conditional Probability"
      ;;
    chapter3_random_variables)
      title="Chapter 3: Random Variables and Discrete Distributions"
      ;;
    chapter4_expectation)
      title="Chapter 4: Expectation"
      ;;
    chapter5a_continuous_uniform)
      title="Chapter 5A: Continuous Random Variables, PDFs, and Uniform Distribution"
      ;;
    chapter5b_normal_exponential)
      title="Chapter 5B: Normal and Exponential Distributions"
      ;;
    chapter6a_moments)
      title="Chapter 6A: Moments, Skewness, and Kurtosis"
      ;;
    chapter6b_mgfs)
      title="Chapter 6B: Moment Generating Functions"
      ;;
    chapter7_joint_distributions)
      title="Chapter 7: Joint Distributions"
      ;;
    chapter8a_transformations)
      title="Chapter 8A: Transformations and Convolutions"
      ;;
    chapter8b_beta_gamma)
      title="Chapter 8B: Beta and Gamma Distributions"
      ;;
    chapter10a_inequalities)
      title="Chapter 10A: Inequalities"
      ;;
    chapter10b_limit_theorems)
      title="Chapter 10B: Limit Theorems"
      ;;
    chapter10c_chisquare_t)
      title="Chapter 10C: Chi-Square and Student \(t\)-Distributions"
      ;;
  esac

  cat > "chapter_build/${name}_standalone.tex" <<EOF
\documentclass[aspectratio=169,9pt]{beamer}

\input{../source/lectures/theme.tex}
\input{../source/lectures/macros.tex}

\title{$title}
\subtitle{MATH/STAT 394: Probability I}
\author{Arman Jahangiri}
\institute{University of Washington \\ Department of Mathematics}
\date{Summer 2026}

\begin{document}

\input{../$chapter}

\end{document}
EOF

  latexmk -pdf -f \
    -interaction=nonstopmode \
    -output-directory=chapter_build \
    "chapter_build/${name}_standalone.tex"

  cp "chapter_build/${name}_standalone.pdf" "docs/${name}.pdf"
  # HTML for chapters is disabled for now.
  # (cd chapter_build && make4ht -u "${name}_standalone.tex" "mathjax")
  # cp "chapter_build/${name}_standalone.html" "docs/${name}.html"
done


# EXAMS

mkdir -p docs/Exams

# Public exam materials linked from the course website.
for exam in \
  midterm \
  midterm_solution \
  midterm-question-bank \
  midterm_practice \
  midterm_practice_solution \
  final \
  final_solution \
  final-question-bank; do

  latexmk -pdf -f \
    -interaction=nonstopmode \
    -output-directory=docs/Exams \
    "source/exams/${exam}.tex"

  (cd source/exams && make4ht -u -d ../../docs/Exams "${exam}.tex" "mathjax") || {
    echo "WARNING: HTML conversion failed for ${exam}; keeping existing published HTML if available." >&2
  }
done


# HOMEWORKS
# HOMEWORKS

mkdir -p docs/HW
mkdir -p docs/HW/solutions

# Regular homework PDFs
for homework in source/homework/HW[0-9]*.tex; do
  name=$(basename "$homework" .tex)

  # Skip solution files here
  if [[ "$name" == *-solution ]]; then
    continue
  fi

  latexmk -pdf -f \
    -interaction=nonstopmode \
    -output-directory=docs/HW \
    "$homework"
    
  (cd source/homework && make4ht -u -d ../../docs/HW "$(basename "$homework")" "mathjax") || { echo "WARNING: HTML conversion failed; keeping existing published HTML if available." >&2; }
done

# Homework solution PDFs
for solution in source/homework/HW*-solution.tex; do
  name=$(basename "$solution" .tex)

  latexmk -pdf -f \
    -interaction=nonstopmode \
    -output-directory=docs/HW/solutions \
    "$solution"
    
  (cd source/homework && make4ht -u -d ../../docs/HW/solutions "$(basename "$solution")" "mathjax") || { echo "WARNING: HTML conversion failed; keeping existing published HTML if available." >&2; }
done



# Clean temporary files
rm -rf chapter_build


# Remove LaTeX/TeX4ht intermediates after the build.
find . -type f \
  \( -name '*.aux' -o -name '*.log' -o -name '*.fls' -o -name '*.fdb_latexmk' \
     -o -name '*.out' -o -name '*.toc' -o -name '*.nav' -o -name '*.snm' \
     -o -name '*.4ct' -o -name '*.4tc' -o -name '*.dvi' -o -name '*.idv' \
     -o -name '*.lg' -o -name '*.tmp' -o -name '*.xref' \) -delete
