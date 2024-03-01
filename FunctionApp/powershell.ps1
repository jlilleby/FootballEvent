# Define API URLs
$apiUrls = @(
    "https://api.example.com/calendar1",
    "https://api.example.com/calendar2"
)

# Iterate over each API URL
foreach ($url in $apiUrls) {
    # Fetch .ics file from API
    $icsData = Invoke-RestMethod -Uri $url -Method Get

    # Parse .ics file (example, actual parsing logic may vary)
    $events = $icsData | ConvertFrom-ICalendar

    # Connect to SQL Database (example connection)
    $connectionString = "Server=tcp:yourserver.database.windows.net,1433;Database=YourDatabase;User ID=yourusername;Password=yourpassword;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $sqlConnection.Open()

    # Insert data into SQL Database
    foreach ($event in $events) {
        $sqlCommand = $sqlConnection.CreateCommand()
        $sqlCommand.CommandText = "INSERT INTO Events (EventName, StartDate, EndDate) VALUES (@EventName, @StartDate, @EndDate)"
        $sqlCommand.Parameters.AddWithValue("@EventName", $event.Summary)
        $sqlCommand.Parameters.AddWithValue("@StartDate", $event.StartDate)
        $sqlCommand.Parameters.AddWithValue("@EndDate", $event.EndDate)
        $sqlCommand.ExecuteNonQuery()
    }

    # Close SQL Connection
    $sqlConnection.Close()
}
