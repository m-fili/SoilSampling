# Soil Sample Generator Shiny App

## Description
This Shiny app simulates soil sampling for Nitrogen, Phosphorus, and Moisture content across 20 distinct plots. It's designed for use in statistics or environmental science classes to help students understand and practice sampling methods, data collection, and basic statistical analysis.

## How to Use
1. **Team Number:** When the app starts, users are prompted to enter a 
team number between 1 and 6. This sets a random seed to ensure reproducibility 
of samples for each team.
2. **Sampling Plots:** There are 20 brown rectangular plots displayed on the app. 
Click on a plot to generate and record sample data for Nitrogen (mg/kg), Phosphorus 
(mg/kg), and Moisture (%).
3. **Data Table:** All sampled data are automatically recorded and displayed in a 
table below the plots.
4. **Download Data:** Users can download their sampled data as a CSV file by clicking 
the "Download CSV" button.

## Installation
Ensure you have R installed on your system. If necessary, install the required packages by running:

```r
install.packages(c("shiny", "DT"))
```

Alternatively, the app includes automatic package checks and installations when you run it.

## Running the App
- Open the R script `app.R` in RStudio.
- Click the "Run App" button in RStudio or run the command `shiny::runApp()` in the R console.

## Running the App directly from GitHub
You can run the app directly from GitHub using the `shiny` package's `runGitHub()` function. 
Run the following code in R:
```r
shiny::runGitHub(username = "m-fili", repo = "SoilSampling")
```

## Intended Use
This app is designed for educational purposes to illustrate random 
sampling, data collection, and confidence interval. It is suitable for classroom 
demonstrations, labs, or homework assignments in courses related to probability and statistics.

