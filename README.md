CoreDataEngineers: Linux ETL and File Management Project
Welcome to my repository. This project serves as my first assignment as a Data Engineer at CoreDataEngineers. The goal of this project is to build an automated data pipeline and a file management system using pure Bash scripting on a Linux operating system.

Everything in this repository has been version-controlled using Git, in accordance with the company's infrastructure standards.

Project Overview
This repository contains two main scripts that handle different aspects of our data infrastructure. The first is an automated ETL pipeline that downloads, cleans, and stores financial data. The second is a utility script that organizes our file directories by moving specific data formats.

Repository Structure
etl.sh: The main Bash script that handles the Extract, Transform, and Load process.

move_files.sh: A utility script that isolates and moves JSON and CSV files into a specific directory.

source_folder/: A directory containing sample JSON and CSV files used to test the file moving script.

1. The ETL Pipeline (etl.sh)
This script automates the retrieval and processing of the 2023 annual enterprise survey dataset. I built it using standard Linux command-line tools, specifically curl for downloading and awk for text processing.

Here is a step-by-step breakdown of how the pipeline works:

Extract: The script reads a URL from an environment variable. If the variable is not set, it defaults to the provided stats.govt.nz link. It uses curl to download the CSV and saves it into a newly created folder called "raw". The script includes checks to confirm the download was successful before moving on.

Transform: Once the raw data is secured, the script uses awk to process the CSV. It renames the "Variable_code" column to "variable_code" to maintain naming consistency. It then filters the dataset to keep only four specific columns: year, Value, Units, and variable_code. This refined dataset is saved as "2023_year_finance.csv" inside a folder called "Transformed".

Load: Finally, the transformed file is copied into a production-ready directory named "Gold". A final verification check runs to ensure the file was successfully loaded.

How to Run the ETL Script
First, ensure the script has executable permissions by running:
chmod +x etl.sh

Then, execute it in your terminal:
./etl.sh

Automated Scheduling
As requested by the engineering manager, this ETL process is scheduled to run automatically every day at midnight (12:00 AM).

To replicate this schedule on your local machine, open your cron table by typing:
crontab -e

Then, add the following line to the bottom of the file. You will need to replace the path with the actual absolute path to the script on your machine:
0 0 * * * /path/to/core_data_etl_project/etl.sh

2. File Mover Utility (move_files.sh)
Data environments can quickly become cluttered. The second task assigned to me was to write a script that helps organize our directories by isolating specific file types.

How it works:
The script targets a designated source directory. It uses a loop to scan for any file ending in .csv or .json. Once identified, it safely moves these files into a consolidated folder named "json_and_CSV". It strictly ignores other file types, like standard text files, ensuring that only the requested data formats are relocated.

How to Run the File Mover Script
Make sure it is executable:
chmod +x move_files.sh

Run the script:
./move_files.sh

Environment Requirements
To run these scripts successfully, you will need a Linux environment, macOS terminal, or Windows Subsystem for Linux (WSL). The scripts rely on bash, curl, and awk, which come pre-installed on almost all standard Unix-like operating systems.
