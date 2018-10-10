function download-newMinecraftServerRelease($urlOfLatestFileWebpage) {
    $latestWebpage = invoke-webrequest $latestLink

    $serverDownloadUrl = ($latestWebpage.links | where "data-action" -eq "server-pack-download").href

    $downloadZipUrl = $baseUrl + $serverDownloadUrl

    if(test-path "/app/server.zip") {
        remove-item -path "/app/server.zip"
    }

    $downloadZip = invoke-webrequest $downloadZipUrl -outfile "/app/server.zip"

    if(!(test-path "/data/MCServer")) {
        New-Item -Path "/data/MCServer" -ItemType Directory
    }

    Expand-Archive -Path "/app/server.zip" -DestinationPath "/data/MCServer" -Force
}

$baseUrl = "https://www.feed-the-beast.com"
$restOfUrl = "/projects/ftb-continuum/files"

$webpage = invoke-webrequest https://www.feed-the-beast.com/projects/ftb-continuum/files

$justTheDownloadLinks = ($webpage.links | where "data-action" -eq "modpack-file-link").href

$maxNum = 0

foreach ($downloadLink in $justTheDownloadLinks) {
    $downloadLink -match "/files/(?<content>\d+)$" | out-null
    $thisNum = $matches['content']
    if ($thisNum -gt $maxNum) {
        $maxNum = $thisNum
    }
}

#if we're already using the latest version, don't bother redownloading
if(test-path "/data/fileMaxNum.txt") {
    $numAlreadyDownloaded = Get-Content -Path "/data/fileMaxNum.txt"
} else {
    $maxNum | out-file -Path "/data/fileMaxNum.txt"
}

$latestLink = $baseUrl + $restOfUrl + "/" + $maxNum

if($maxNum -gt $numAlreadyDownloaded) {
    download-newMinecraftServerRelease($latestLink)
}

if(!(test-path "/data/MCServer/eula.txt")) {
    "eula=true" | out-file -Path "/data/MCServer/eula.txt"
}

invoke-expression -command "chmod +x /data/MCServer/ServerStart.sh"
invoke-expression -command "sh /data/MCServer/ServerStart.sh"