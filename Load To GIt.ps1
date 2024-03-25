# get all sessions from the API

$AllSessions = Get-SQLBitsSession -all

foreach ($Session in $AllSessions) {
    if ($null -ne $session.UploadUri) {
        $message = "UploadUri found for {0}" -f $Session.Title
        Write-Verbose $message
        $FileName = $Session.UploadName
        $FileUri = $Session.UploadUri
        $Day = $Session.startsAt.DayOfWeek

            # Remove invalid characters from the file name
            $invalidChars = [IO.Path]::GetInvalidFileNameChars()

        $Title = "{0}_{1}" -f $Session.Title, $Session.Speakers
        $title = $title -replace "[$([regex]::Escape($invalidChars -join ''))]", ""
        $downloadDirectory = Join-Path -Path "2024" -ChildPath $day -AdditionalChildPath $title


        # Remove any spaces from the file name
        $downloadDirectory = $downloadDirectory -replace '\s', '-'

        # Set the full path for the downloaded file
        $downloadPath = Join-Path -Path $downloadDirectory -ChildPath $fileName

        if (-not (Test-Path -Path $downloadDirectory)) {
            New-Item -Path $downloadDirectory -ItemType Directory
        }

        # Download the file using the file URL
        Invoke-WebRequest -Uri $FileUri -OutFile $downloadPath

    } else {
        $message = "No UploadUri for {0}" -f $Session.Title
        Write-Verbose $message
    }

}
