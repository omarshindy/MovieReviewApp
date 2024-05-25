
## Features

- CSV Uploader
- Listing View for Movies and Reviews



## Technical Description

- what's implemented now that we have independent CSV uploader
- First we check for CSV files to be matching the structure shared
- Then we divide the CSV into chunks before we load file into memory
- Then we send each chunk into thread with the upload tasks needed
- we process the file then build chunks to bulk seeded to the database using DB transactions
- Database used here is PostgreSql


## Notes and Further Work

- Author field is implemented to be array of strings which causes heavy processing in filtering and retrieving
- the best way to achive this is to build has many relation with review and movie author for better performance
