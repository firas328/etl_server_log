# cp-access-log.sh
# This script downloads the file 'web-server-access-log.txt.gz'
# from "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/".

# The script then extracts the .txt file using gunzip.

# The .txt file contains the timestamp, latitude, longitude 
# and visitor id apart from other data.

# Transforms the text delimeter from "#" to "," and saves to a csv file.
# Loads the data from the CSV file into the table 'access_log' in PostgreSQL database.
# Download the access log file

wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Bash%20Scripting/ETL%20using%20shell%20scripting/web-server-access-log.txt.gz"
# Unzip the file to extract the .txt file.
gunzip -f web-server-access-log.txt.gz
# Extract phase

echo "Extracting data"

# Extract the columns 1 (timestamp), 2 (latitude), 3 (longitude) and 
# 4 (visitorid)

cut -d"#" -f1-4 web-server-access-log.txt > extracted-data.txt 
# Transform phase
echo "Transforming data"

# read the extracted data and replace the colons with commas.
tr "#" "," < extracted-data.txt > /home/transformed-data.csv
# Load phase
echo "Loading data"
export PGPASSWORD=strong_password
# Send the instructions to connect to 'postgres' and
# copy the file to the table 'access_log' through command pipeline.
echo "CREATE TABLE access_log (timestamp TIMESTAMP,latitude FLOAT,longitude FLOAT,visitorid char(37))" | psql --username=postgres  --host=db
echo "access_log table  created "
echo "\COPY access_log  FROM '/home/transformed-data.csv' DELIMITERS ',' CSV HEADER;" | psql --username=postgres  --host=db