$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

$fn = '09_input.txt'
$orgData = (Get-Content .\$fn) | ForEach-Object { , @($_ -split '' | Where-Object { $_ }) }
$horData = (Get-Content .\$fn) | ForEach-Object { , @($_ -split '' | Where-Object { $_ }) }
$vertData = (Get-Content .\$fn) | ForEach-Object { , @($_ -split '' | Where-Object { $_ }) }

function checkHights ($inArr) {
    1..2 | ForEach-Object {
        $inArr | ForEach-Object { [array]::Reverse($_) }
        for ($y = 0; $y -lt $inArr.Length; $y++) {
            for ($x = 0; $x -lt ($inArr[0].Length - 1); $x++) {
                if ($inArr[$y][$x] -eq 9) { continue }
                if ($inArr[$y][$x] -gt $inArr[$y][$x + 1]) { $inArr[$y][$x] = 9 }
            }
        }
    }
    $inArr
}

function rotArr ($inArr) {
    $rotated = @()
    for ($i = 0; $i -lt $inArr[0].Length; $i++) {
        $rotated += , @($inArr | ForEach-Object { $_[$i] | Where-Object { $_ } })
    }
    $rotated
}

#horizontal pass
$horData = checkHights $horData

#vertical pass
$rotated = checkHights (rotArr $vertData)
$rotatedBack = rotArr $rotated

#compare
$total = for ($y = 0; $y -lt $horData.Length; $y++) {
    for ($x = 0; $x -lt ($horData[0].Length); $x++) {
        if ($horData[$y][$x] -eq 9) { continue }
        if ($horData[$y][$x] -eq $rotatedBack[$y][$x]) { [int]$horData[$y][$x] + 1 }
    }
}

Write-Host 'Part 1 :' ($total | Measure-Object -Sum).Sum


#PArt2
$lows = for ($y = 0; $y -lt $horData.Length; $y++) {
    for ($x = 0; $x -lt ($horData[0].Length); $x++) {
        if ($horData[$y][$x] -eq 9) { continue }
        if ($horData[$y][$x] -eq $rotatedBack[$y][$x]) { , @($y, $x) }
    }
}

#mark lowest points
for ($i = 0; $i -lt $lows.Count; $i++) {
    $orgData[$lows[$i][0]][$lows[$i][1]] = "B$i"
}

#flow
do {
    for ($y = 0; $y -lt $orgData.Length; $y++) {
        for ($x = 0; $x -lt ($orgData[0].Length); $x++) {
            if ($orgData[$y][$x] -eq 9) { continue }
            if ($orgData[$y][$x] -like 'B*') { continue }

            if ($y -gt 0) { if ($orgData[$y - 1][$x] -like 'B*') { $orgData[$y][$x] = $orgData[$y - 1][$x] } }
            if ($y -lt $orgData.Length -1) { if ($orgData[$y + 1][$x] -like 'B*') { $orgData[$y][$x] = $orgData[$y + 1][$x] } }
            if ($x -gt 0) { if ($orgData[$y][$x - 1] -like 'B*') { $orgData[$y][$x] = $orgData[$y][$x - 1] } }
            if ($x -lt $orgData[0].Length) { if ($orgData[$y][$x + 1] -like 'B*') { $orgData[$y][$x] = $orgData[$y][$x + 1] } }
        }
    }
} while ($orgdata | ForEach-Object { $_ | Where-Object { $_ -notlike 'B*' -and $_ -ne 9 } })

(($orgData | ForEach-Object { $_ | Where-Object { $_ -ne 9 } }) | Group-Object | Sort-Object count -Descending -Top 3)


$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"