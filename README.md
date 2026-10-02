# Selenium toxicity in *Exaiptasia diaphana* — analysis code

https://github.com/caitlinyounis-code/selenium-toxicity-exaiptasia-analysis

Analysis code for:

> Younis, C., Camp, E.F., Raina, J.-B., Cresswell, T. & Gissi, F. (2025)
> Effects of selenium on the model cnidarian *Exaiptasia diaphana* and its symbiotic algae.
> *Aquatic Toxicology* **287**: 107495. https://doi.org/10.1016/j.aquatox.2025.107495

## Contents

| Path | Contents |
|---|---|
| `R/Ecotox_script.R` | Assumption checks, one-way ANOVA with Dunnett post-hoc, and Kruskal–Wallis with pairwise comparisons. Requires `data/Figure_1.csv` and `data/Figure_2.csv` |
| `R/02_bioaccumulation_figure.R` | Log–log bioaccumulation against dissolved selenium for host and symbiont, with fitted regressions. Self-contained: data are hard-coded |
| `data/` | Input data (see `data/README.md`) |
| `output/figures/` | `bioaccumulation_loglog.png`, written by `02_bioaccumulation_figure.R` |

## What the script does

1. Loads `vegan`, `dplyr`, `ggpubr`, `gplots`, `car` and `DescTools`.
2. Checks parametric assumptions on the tissue-concentration data: Levene's test for homogeneity of variance and Shapiro–Wilk for normality.
3. Where assumptions hold, fits a one-way ANOVA across treatment groups and follows it with a Dunnett test, comparing each selenium treatment against the control only.
4. Where assumptions fail, uses Kruskal–Wallis with pairwise comparisons instead.

The script is the version used for the published analysis and has not been
restructured. It is run as a single file from the repository root:

```r
source("R/02_bioaccumulation_figure.R")   # self-contained
source("R/Ecotox_script.R")               # needs both CSVs in data/
```

## Reproducibility

Record the package versions used, from the repository root:

```r
writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
```

## Citing

Cite the paper for the science and the archived release for the code — see
`CITATION.cff`, and the Zenodo DOI once a release is made.

## Licence

Code under the MIT Licence (`LICENSE`); data under CC BY 4.0.

## Publishing checklist

- [ ] Run the script end to end from the repository root and generate `sessionInfo.txt`
- [ ] Commit and publish (GitHub Desktop: Add Local Repository → Commit → Publish, public)
- [ ] Zenodo: sign in at zenodo.org with GitHub, Settings → GitHub, enable this repository
- [ ] GitHub: Releases → Create a new release, tag `v1.0.0`, publish — Zenodo mints the DOI
- [ ] Add the Zenodo DOI to the CV and to caitlinyounis.owlstown.net
