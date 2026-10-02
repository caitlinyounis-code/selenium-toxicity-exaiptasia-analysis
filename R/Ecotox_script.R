#Ecotox script

install.packages("DescTools")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("AndriSignorell/DescTools")


#Load required packages
library(vegan)
library(dplyr)
library(ggpubr)
library(gplots)
library(car)
library(DescTools)

# Figure 1: load data
figure1 <- Figure_1

# Reorder the dataset
figure1$group <- ordered(figure1$group,
                         levels = c("control", "76_Se", "160_Se", "245_Se", "345_Se", "570_Se", "1100_Se"))

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# One-way ANOVA: host
res.aov <- aov(animal_log ~ group, data = figure1)

# ++++++++++++++++++++++++++++++
# Check Assumptions
# ++++++++++++++++++++++++++++++

# 1. Homogeneity of variances
plot(res.aov, 1)

# Levene test: if p is larger than 0.05 then there is no evidence to suggest that the variance across groups is statistically significantly different. Therefore, we can assume the homogeneity of variances in the different treatment groups.
leveneTest(animal_log ~ group, data = figure1)

#example write up
#Levene's test showed that the variances for concentration of Se in animal tissues were equal, F(6,28) = 1.0442, p = 0.4185


# 2. Normality
plot(res.aov, 2)

# Shapiro-Wilk test: if p is larger than 0.05 then normality is not violated
#If p ??? 0.05: then the null hypothesis can be rejected (i.e. the variable is NOT normally distributed).
#If p > 0.05: then the null hypothesis cannot be rejected (i.e. the variable MAY BE normally distributed).
aov_residuals <- residuals(object = res.aov )
shapiro.test(x = aov_residuals )

#example write up
#a Shapiro-Wilk test was performed on the concentrations measured in the animal tissues and did not show evidence of non-normality (W = 0.9792, p-value = 0.7328)

# +++++++++++++++++++++++++++++

# Summary of ANOVA
summary(res.aov)

# PostHoc test called Dunnett Test to only compare control vs. treatment
DunnettTest(x=figure1$animal_log, g=figure1$group)


#Example write up
# A one-way ANOVA revealed a significant effect of the total concentration of Se in animal tissues between treatments and the 0.3 ug/L group, F(6,28) = 34.79, p < 0.001.


#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

# Kruskal-Wallis: symbiont
figure1 <- read.csv("data/Figure_1.csv")

# Data do not meet the assumptions of parametric tests. 
kruskal.test(symbiont ~ group, data = figure1)

# Multiple pairwise-comparison between groups
pairwise.wilcox.test(figure1$symbiont, figure1$group,
                     p.adjust.method = "BH")

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

# Kruskal-Wallis: ratio
figure1 <- read.csv("data/Figure_1.csv")

# Data do not meet the assumptions of parametric tests. 
kruskal.test(ratio ~ group, data = figure1)

# Multiple pairwise-comparison between groups
pairwise.wilcox.test(figure1$ratio, figure1$group,
                     p.adjust.method = "BH")

# Figure 1: load data
figure1 <- read.csv("data/Figure_1.csv")

# Reorder the dataset
figure1$group <- ordered(figure1$group,
                         levels = c("control", "76_Se", "160_Se", "245_Se", "345_Se", "570_Se", "1100_Se"))

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Figure 2: load data
figure2 <- read.csv("data/Figure_2.csv")

# Reorder the dataset
figure2$group <- ordered(figure2$group,
                         levels = c("control", "76_Se", "160_Se", "245_Se", "345_Se", "570_Se", "1100_Se"))

# One-way ANOVA: host
res.aov <- aov(diff.4.3 ~ group, data = figure2)

# ++++++++++++++++++++++++++++++
# Check Assumptions
# ++++++++++++++++++++++++++++++

# 1. Homogeneity of variances
plot(res.aov, 1)

# Levene test: if p is larger than 0.05 then there is no evidence to suggest that the variance across groups is statistically significantly different. Therefore, we can assume the homogeneity of variances in the different treatment groups.
leveneTest(diff.4.3 ~ group, data = figure2)

# 2. Normality
plot(res.aov, 2)

# Shapiro-Wilk test: if p is larger than 0.05 then normality is not violated
aov_residuals <- residuals(object = res.aov )
shapiro.test(x = aov_residuals )

# +++++++++++++++++++++++++++++

# Summary of ANOVA
summary(res.aov)

# PostHoc test called Dunnett Test to only compare control vs. treatment
DunnettTest(x=figure2$diff.4.3, g=figure2$group)
