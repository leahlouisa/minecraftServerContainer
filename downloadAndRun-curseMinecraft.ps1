function download-newMinecraftServerRelease($currentVersion) {
  if(test-path "/app/server.zip") {
    remove-item -path "/app/server.zip"
  }
  $nextVersion = [int]$currentVersion + 1
  $errorCountBeforeDownloadAttempt = $error.count
  $url = "https://media.forgecdn.net/files/2948/426/RAD-Serverpack-1.$($nextVersion).zip"
  write-host $url
  invoke-webrequest $url -OutFile "/app/server.zip"
#  curl -o "/app/server.zip" "https://media.forgecdn.net/files/2948/426/RAD-Serverpack-1.$($nextVersion.zip)"
  if($error.count -eq $errorCountBeforeDownloadAttempt) {
    if(!(test-path "/data/MCServer")) {
        New-Item -Path "/data/MCServer" -ItemType Directory
    }

    $nextVersion | out-file -Path "/data/fileMaxNum.txt"

    Expand-Archive -Path "/app/server.zip" -DestinationPath "/data/MCServer" -Force

    Copy-Item -Path "/app/HTKTB.png" -Destination "/data/MCServer/server-icon.png" -Force
  }
}

#figure out our current version
if(test-path "/data/fileMaxNum.txt") {
    $numAlreadyDownloaded = Get-Content -Path "/data/fileMaxNum.txt"
} else {
    "37" | out-file -Path "/data/fileMaxNum.txt"
    $numAlreadyDownloaded = 37
}

download-newMinecraftServerRelease($numAlreadyDownloaded)

if(!(test-path "/data/MCServer/eula.txt")) {
    "eula=true" | out-file -Path "/data/MCServer/eula.txt"
}

"export MAX_RAM=`"6048M`"" | out-file -Path "/data/MCServer/settings-local.sh" -Force

invoke-expression -command "chmod +x /data/MCServer/ServerStart.sh"
invoke-expression -command "sh /data/MCServer/ServerStart.sh"
