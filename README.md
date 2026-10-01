# MATH 394: Probability I — Summer 2026

Course materials for **MATH/STAT 394: Probability I** at the University of Washington.

## Repository structure

```text
.
├── assets/
│   ├── annotated/       # Annotated lecture PDFs and annotated exam material
│   └── figures/         # Images and interactive HTML visualizations used by the course
├── source/
│   ├── lectures/        # Main slide deck, theme/macros, and chapter source files
│   ├── homework/        # Homework and solution LaTeX sources
│   ├── exams/           # Exam, practice, solution, and question-bank sources
│   ├── handouts/        # Project, tables, distribution sheets, supplementary material
│   └── syllabus.tex     # Syllabus source
├── site/
│   └── index.html       # Source for the course homepage
├── scripts/
│   └── build.sh         # Full website/document build script
├── docs/                # Generated GitHub Pages output (not committed)
├── .github/workflows/   # GitHub Pages build/deploy workflow
├── build.sh             # Convenience wrapper for scripts/build.sh
└── LICENSE
```

## Build

From the repository root:

```bash
./build.sh
```

The build generates the deployable site in `docs/`. GitHub Actions uses the same build script and deploys `docs/` to GitHub Pages.

## Organization policy

- Editable source material belongs under `source/`, `assets/`, or `site/`.
- `docs/` is generated at build/deploy time and is intentionally not committed (except `.gitkeep`).
- LaTeX auxiliary files (`.aux`, `.log`, `.fls`, `.fdb_latexmk`, etc.) are ignored and removed from `docs/` after builds.
- Annotated PDFs that previously existed in two different locations have been consolidated under `assets/annotated/`.
- Small legacy/prebuilt HTML/CSS snapshots needed as fallbacks live under `site/static/`; large generated PDFs are not duplicated in the repository.
- Existing filenames are largely preserved so course-site links and historical references remain stable.
