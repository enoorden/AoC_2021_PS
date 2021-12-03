Write-Host 'Day3'

$data = Get-Content .\03_input.txt

#Part1
$nrbits = $data[0].length

[string]$gammaStr = ''
foreach ($i in 0..($nrbits - 1)) {
    $gammaStr += ($data | Group-Object { $_.substring($i, 1) } | Sort-Object count -desc | Select-Object -First 1).name
}

$gamma = [Convert]::ToInt32($gammaStr, 2)

$epsilon = -bnot $gamma

#powershell bnot produces signed results.. so we have to cut a few bits off, and convert it back to int
$epsilonStr = [Convert]::ToString($epsilon, 2)
$epsilonStr = $epsilonStr.substring($epsilonStr.Length - $nrbits, $nrbits)
$epsilon = [Convert]::ToInt32($epsilonStr, 2)

Write-Host "Part1 : $($gamma * $epsilon)"


#Part2
$nrbits = $data[0].length

$oxygenData = $data
foreach ($i in 0..($nrbits - 1)) {
    $OxygenData = ($oxygenData | Group-Object { $_.substring($i, 1) } | Sort-Object count,name -desc | Select-Object -First 1).group
    if ($oxygenData.count -eq 1) { break }
}

$CO2Data = $data
foreach ($i in 0..($nrbits - 1)) {
    $CO2Data = ($CO2Data | Group-Object { $_.substring($i, 1) } | Sort-Object count,name | Select-Object -First 1).group
    if ($CO2Data.count -eq 1) { break }
}

Write-Host "Part2 : $([Convert]::ToInt32($oxygenData, 2) * [Convert]::ToInt32($CO2Data, 2))"