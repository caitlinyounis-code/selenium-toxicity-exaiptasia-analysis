# Data

Both files are the data behind the published figures. The measured values are
unchanged from the versions used for the published analysis. A `replicate`
column has been added to each, linking every row to the raw measurements in the
paper's Supplementary Information, and `Figure_2.csv` gains a `timepoint`
column (see below).

Source sheets in the Supplementary Information workbook: `ICP-MS Data`
("Tissue Concentrations of Se (µg/g dry tissue)") and `Replicate Raw Data`
("SIZE Oral Disk (mm)", T0-T96).

## `Figure_1.csv` — tissue selenium

35 rows: seven exposure groups x five replicates, giving 6 and 28 degrees of
freedom in the one-way ANOVA. Only five of the ten tanks per group were
analysed for tissue selenium.

| Column | Contents |
|---|---|
| `replicate` | Tank identifier, `<group>.<tank>`; controls are `c1`-`c10` |
| `group` | Exposure group: `control`, `76_Se`, `160_Se`, `245_Se`, `345_Se`, `570_Se`, `1100_Se` |
| `host` | Se in host tissue (µg Se g⁻¹ dry tissue) |
| `animal_log` | log₁₀(`host` + 1) |
| `symbiont` | Se in the Symbiodiniaceae fraction (µg Se g⁻¹ dry tissue) |
| `symbiont_log` | log₁₀(`symbiont` + 1) |
| `animal&symbiont` | Combined host + symbiont |
| `animal&symbiont_log` | log₁₀(combined + 1) |
| `ratio` | Host : symbiont ratio |
| `ratio_log` | log₁₀(`ratio` + 1) |

Group labels are **measured** dissolved selenium concentrations (µg L⁻¹) from
Na₂SeO₃ dosing, not nominal targets. Tissue values are the Supplementary
ICP-MS values rounded to two decimal places (verified against them).

The `*_log` columns are **log₁₀(x + 1)**, not plain log₁₀ — verified against
the untransformed columns for all four pairs (agreement to 5 × 10⁻¹⁰). The
plus-one offset keeps the control values, as low as 0.03, away from zero.

`read.csv()` converts the `&` in two column names to `.`, so inside R these are
`animal.symbiont` and `animal.symbiont_log`.

## `Figure_2.csv` — oral disc size

70 rows: the same seven groups with **ten** replicates each (all tanks were
measured for size), giving 6 and 63 degrees of freedom.

| Column | Contents |
|---|---|
| `replicate` | Tank identifier, as above |
| `group` | Exposure group, as above |
| `difference` | Change in **oral disc diameter** (mm): the measurement named in `timepoint` minus T0 |
| `diff+4.3` | `difference` shifted by a positive constant (see below) |
| `timepoint` | Which measurement was differenced against T0 |

For 65 of the 70 rows `difference` is T96 − T0, verified exactly against the
raw sheet. The exceptions are all in the 1100 µg L⁻¹ group, where four rows —
`1100.1`, `1100.2`, `1100.4` and `1100.9` — are T48 − T0 instead. Three of
those four (`1100.1`, `1100.4`, `1100.9`) have no T96 oral-disc measurement
recorded; `1100.2` does have one, which would give −3.93, but the published
file uses its T48 value. The fifth exception, `1100.3`, is described below.

Two further points about this group, for anyone reconciling the files. In the
oral-disc sheet all ten replicates have complete T0, T24, T48 and T72 values,
and only `1100.1`, `1100.3`, `1100.4` and `1100.9` lack T96. The mortality
table (Supplementary Figure S3) instead reports, for 1100 µg L⁻¹ alone,
four deaths at 48 h and six at 72 h out of n = 10. Those two records cannot
both be literally true, and the reason four rows use T48 is therefore recorded
here as an observation about the data rather than as a consequence of the
recorded times of death.

**One value does not reproduce.** Replicate `1100.3` is recorded as −4.33,
which matches none of its own measurements (its T24, T48 and T72 differences
are +0.80, −2.65 and −3.46). It equals 1.31 − 5.64, the T96 of replicate
`1100.2` minus the T0 of `1100.3` — consistent with a one-row offset where the
blank T96 cell of a dead animal picked up its neighbour. The published value is
retained here so the file continues to reproduce the published statistics.
Substituting that replicate's own last measurement before death (−3.46) moves
the one-way ANOVA from F = 5.800, p = 7.4 × 10⁻⁵ to F = 5.572,
p = 1.1 × 10⁻⁴ — the same conclusion.

**The shift in `diff+4.3` is +4.4, not +4.3.** It is uniform across all 70 rows
and puts the most negative value (−4.33) just above zero, so the column is
positive throughout. The name is kept as published because
`R/Ecotox_script.R` refers to it (as `diff.4.3`, `read.csv()` having converted
the `+`). That script runs its ANOVA and Dunnett test on the shifted column; a
uniform shift changes neither the F statistic nor the Dunnett contrasts.

`R/02_bioaccumulation_figure.R` does not read either file: its data are
hard-coded.
