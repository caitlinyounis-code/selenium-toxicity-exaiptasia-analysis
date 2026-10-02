# 02_bioaccumulation_figure.R
# Selenium bioaccumulation in Exaiptasia diaphana and its Symbiodiniaceae
# against dissolved exposure concentration.
#
# Younis, C., Camp, E.F., Raina, J.-B., Cresswell, T. & Gissi, F. (2025)
# Aquatic Toxicology 287: 107495. doi:10.1016/j.aquatox.2025.107495
#
# Self-contained: raw data are hard-coded below, so this script needs no
# external files. Values were cross-checked against data/Figure_1.csv.

library(ggplot2)

# ---- Raw data -----------------------------------------------------------
# exposure_conc: measured dissolved Se in the exposure water (ug/L).
#                These are the measured exposure concentrations reported in
#                the paper, not nominal dosing targets. 0 = unexposed control.
# replicate    : tank identifier, as in the paper's Supplementary Information
#                ('<exposure group>.<tank>'; controls are c1-c10). Only five of
#                the ten tanks per group were analysed for tissue selenium.
# animal       : Se in host tissue (ug Se/g dry tissue)
# symbiont     : Se in the Symbiodiniaceae fraction (ug Se/g dry tissue)
#
# Rows are ordered by exposure group, five replicates per group.
selenium_data <- data.frame(
  exposure_conc = rep(c(0, 76, 160, 245, 345, 570, 1100), each = 5),
  replicate     = c("c1", "c5", "c7", "c8", "c10",
                    "76.1", "76.4", "76.6", "76.8", "76.10",
                    "160.1", "160.4", "160.6", "160.8", "160.10",
                    "245.2", "245.4", "245.5", "245.7", "245.9",
                    "345.1", "345.4", "345.6", "345.7", "345.9",
                    "570.4", "570.5", "570.6", "570.9", "570.10",
                    "1100.2", "1100.4", "1100.6", "1100.8", "1100.10"),
  animal = c(0.03, 0.10, 0.09, 0.11, 0.05,
             0.04, 0.03, 0.03, 0.03, 1.41,
             1.64, 1.25, 3.07, 1.21, 7.35,
             6.47, 5.35, 2.65, 2.05, 3.87,
             6.99, 27.57, 23.98, 9.63, 21.10,
             44.54, 21.15, 33.24, 28.92, 8.22,
             53.97, 170.53, 28.08, 22.72, 16.41),
  symbiont = c(0.09, 0.09, 0.04, 0.08, 0.04,
               0.03, 0.03, 0.03, 0.03, 0.86,
               0.97, 0.76, 1.39, 0.64, 3.59,
               2.51, 3.56, 1.14, 1.15, 0.97,
               4.24, 2.80, 8.27, 4.39, 5.52,
               17.05, 8.57, 10.46, 7.15, 4.17,
               25.38, 101.02, 13.16, 7.11, 9.44),
  stringsAsFactors = FALSE
)

# Controls (exposure_conc = 0) drop out of the log-scaled plot.

# Long format in base R, so ggplot2 is the only dependency.
data_long <- rbind(
  data.frame(selenium_data[c("replicate", "exposure_conc")],
             organism = "Aiptasia",        bioaccumulation = selenium_data$animal),
  data.frame(selenium_data[c("replicate", "exposure_conc")],
             organism = "Symbiodiniaceae", bioaccumulation = selenium_data$symbiont)
)
data_long$organism <- factor(data_long$organism,
                             levels = c("Aiptasia", "Symbiodiniaceae"))

exposed <- data_long[data_long$exposure_conc > 0, ]

# ---- Figure -------------------------------------------------------------
p <- ggplot(exposed, aes(x = exposure_conc, y = bioaccumulation,
                         colour = organism, fill = organism)) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.25, linewidth = 0.8) +
  geom_point(size = 2.6, alpha = 0.85) +
  scale_x_log10(breaks = c(100, 300, 1000), labels = c("100", "300", "1000")) +
  scale_y_log10(breaks = c(0.1, 1, 10, 100), labels = c("0.1", "1.0", "10.0", "100.0")) +
  scale_colour_manual(values = c(Aiptasia = "black", Symbiodiniaceae = "gray50")) +
  scale_fill_manual(values = c(Aiptasia = "gray60", Symbiodiniaceae = "gray75")) +
  labs(x = expression(Log[10]~"Dissolved Selenium Concentration ("*mu*"g/L)"),
       y = expression(Log[10]~"Bioaccumulation ("*mu*"g Se/g tissue)")) +
  theme_classic() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        text        = element_text(family = "sans", size = 11),
        axis.text   = element_text(family = "sans", size = 11, colour = "black"),
        axis.title  = element_text(family = "sans", size = 11),
        legend.text = element_text(family = "sans", size = 11),
        legend.position = "bottom",
        legend.title = element_blank())

print(p)
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
ggsave("output/figures/bioaccumulation_loglog.png", p,
       width = 150, height = 160, units = "mm", dpi = 300)

# ---- Regressions drawn in the figure ------------------------------------
for (o in levels(exposed$organism)) {
  d <- exposed[exposed$organism == o, ]
  cat("\n---", o, "--- log10(bioaccumulation) ~ log10(exposure)\n")
  print(summary(lm(log10(bioaccumulation) ~ log10(exposure_conc), data = d)))
}

# ---- Host-symbiont scaling (all 35 replicates, controls included) -------
cat("\n--- Pearson correlation, host vs symbiont (untransformed) ---\n")
print(cor(selenium_data$animal, selenium_data$symbiont))
cat("\n--- log10(symbiont) ~ log10(animal) ---\n")
print(summary(lm(log10(symbiont) ~ log10(animal), data = selenium_data)))
