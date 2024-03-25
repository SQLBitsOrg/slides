$ModuleName = 'SQLBitsPS'
If(-not(Get-Module -ListAvailable -Name $ModuleName)) {
    Import-Module -Name $ModuleName -AllowPreRelease
}else{
    Update-Module -Name $ModuleName -AllowPreRelease
}

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

Rename-Item -LiteralPath '2024/Saturday/Air-Traffic-Control-(Data-Governance)-with-Databricks-Unity-Catalog,-tips,-tricks-and-best-practices_Liping-Huang,-Vuong-Nguyen/Air Traffic Control (Data Governance) with Databricks Unity Catalog, tips, tricks and best practices.pptx' -newName 'slides.pptx'
Rename-Item -LiteralPath '2024/Thursday/Managing-the-Challenge-of-Monitoring-Growing,-Multi-platform-Database-Estates_Grant-Fritchey,-Laura-Copeland/Redgate Sponsor Session - Managing the Challenge of Monitoring Growing, Multi-platform Database Estates.pptx' -newName 'slides.pptx'
Rename-Item -LiteralPath '2024/Thursday/More-than-''just''-a-Data-Catalogue---Boarding-the-Tour-through-the-Microsoft-Purview-Universe_Wolfgang-Strasser/SQLBITS2024_More than just a Data Catalog - Microsoft Purview Universe_WolfgangStrasser.pdf' -newName 'slides.pptx'