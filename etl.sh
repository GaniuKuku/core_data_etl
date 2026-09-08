#!/bin/bash

# Set Environment Variables
URL=${CSV_URL:-"https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"}

echo "Staring ETL Process..."

# EXTRACT
echo "Step 1: Extracting data..."

# Create the 'raw' directory
mkdir -p raw

# Download the file and save to 'raw' folder
curl -o raw/raw_data.csv "$URL"

# Confirm the file was saved
if [ -f "raw/raw_data.csv" ]; then
    echo "SUCCESS: Data successfully downloaded and saved in the 'raw' folder."
else
    echo "ERROR: Failed to download data."
    exit 1
fi

# TRANSFORM
echo "Step 2: Transforming data..."

# Create 'Transformed' directory
mkdir -p Transformed

# Using 'awk' to process the csv file
awk '
BEGIN {
    FS = ","
    OFS = ","
}
NR==1 {
    # Find column indices based on headers
    for (i=1; i<=NF; i++) {
        gsub(/\r/, "", $i); 
        if ($i == "Year" || $i == "year") year_idx = i;
        if ($i == "Value") value_idx = i;
        if ($i == "Units") units_idx = i;
        if ($i == "Variable_code") var_idx = i;
    }
    # Print the renamed headers
    print "year", "Value", "Units", "variable_code"
}
NR>1 {
    # Remove carriage returns from the last column before printing data rows
    gsub(/\r/, "", $NF);
    # Print only the specific columns we found in row 1
    print $year_idx, $value_idx, $units_idx, $var_idx
}' raw/raw_data.csv > Transformed/2023_year_finance.csv

# Confirm transformation by checking if the file exists AND is not empty (-s)
if [ $? -eq 0 ] && [ -s "Transformed/2023_year_finance.csv" ]; then
    echo "SUCCESS: Data transformed and saved into the 'Transformed' folder."
else
    echo "ERROR: Transformation failed."
    exit 1
fi


# LOAD
echo "Step 3: Loading data..."

# Create 'Gold' directory
mkdir -p Gold

# Copy the transformed file into the Gold directory
cp Transformed/2023_year_finance.csv Gold/

# Confirm the file was loaded
if [ -f "Gold/2023_year_finance.csv" ]; then
    echo "SUCCESS: Data successfully loaded into the 'Gold' folder."
else
    echo "ERROR: Failed to load data to Gold."
    exit 1
fi

echo "ETL Process Completed Successfully!"
