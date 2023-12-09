$Foder = 'C:\DrvBackup\'
Write-Host "开始读取驱动:$DeviceName";

$Drvs =  Get-WmiObject -Query "SELECT * FROM Win32_PnPSignedDriver Where Manufacturer!='Microsoft' AND InfName LIKE 'OEM%'"
IF(Test-Path $Foder){
    Remove-Item -Force -Recurse -Path $Foder
}
$TMP = New-Item -ItemType Directory -Path $Foder
foreach($drv in $Drvs){
    $InfName = $drv.InfName
    $DeviceName = $drv.DeviceName
    $drvpath = $Foder + $InfName
    IF(Test-Path -Path $drvpath){
        CONTINUE;
    }
    Write-Host "开始备份驱动:$DeviceName";
    $TMP = New-Item -ItemType Directory -Path $drvpath
    $TMP = pnputil /export-driver $infname $drvpath
    Add-Content -Path "$drvpath\desktop.ini" -Value "[.ShellClassInfo]`nLocalizedResourceName=$DeviceName" 
    $TMP = attrib +r $drvpath
}
Write-Host "驱动备份完成:$Foder";
