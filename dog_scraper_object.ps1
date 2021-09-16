# Created by - Joel Dellar
# Access class that contains Dog Picture downloading logic
class DogAccess {
    [string]$apiUrl
    [string]$savePath
    [string]GetDog ()
    {
        $apiResponse = Invoke-RestMethod -Uri $this.apiUrl
        # Split done to obtain the file name from the URL the API provides, "-1" represents all the content after the last '/' in the URL
        $fileName = $apiResponse.message.split("/")[-1]
        Invoke-RestMethod -Uri $apiResponse.message -OutFile ($this.savePath + $fileName)
        return $fileName
    }
}

# Log class that contains log writing logic
class LogAccess{
    [string]$savePath
    [void]WriteLog ([string]$message)
    {
        Add-Content $this.savePath -value "$(Get-Date -Format 'u') | $message"
    }
}

# Manager class that manages the whole use-case of downloading dog pics and writing to log file
class DogManager {
    [DogAccess]$DogAccessor
    [LogAccess]$LogAccessor
    [void]Run ()
    {
    try
    {
        $downloadedFile = $this.DogAccessor.GetDog()
        $this.LogAccessor.WriteLog($downloadedFile)
    }
    # Logs error if dog photo fails to download.
    catch
    {
        $this.LogAccessor.WriteLog("An error has occurred, the job was not complete.")
    }
    }
}

# Function used to securely create DogAccess object
function DogAccessGenerator($savePath, $apiUrl) {
    $generated = New-Object DogAccess
    $generated.apiUrl = $apiUrl
    $generated.savePath = $savePath
    return $generated
}

# Function used to securely create LogAccess object
function LogAccessGenerator($savePath) {
    $generated = New-Object LogAccess
    $generated.savePath = $savePath
    return $generated
}

# Function used to securely create DogManager object
function DogManagerGenerator ($logSavePath, $dogSavePath, $apiUrl) {
    $generated = New-Object DogManager
    $generated.LogAccessor = LogAccessGenerator $logSavePath
    $generated.DogAccessor = DogAccessGenerator $dogSavePath $apiUrl
    return $generated
}

# Main logic to run the program
function main () {
    $manager = DogManagerGenerator "log.txt" "/Users/joel/Documents/dog_scraper/" "https://dog.ceo/api/breeds/image/random"
    $manager.Run()
}

main
