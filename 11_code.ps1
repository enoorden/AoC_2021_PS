$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day10'

if ($data) { Remove-Variable data }
$data = (Get-Content .\11_input.txt) | ForEach-Object { , [int[]]@($_ -split '' | Where-Object { $_ }) }

$xx = $data[0].Length
$yy = $data.Length

function Flash($data, $pos) {
    if ($data[$pos[0]][$pos[1]] -eq 0) { return }

    $data[$pos[0]][$pos[1]] = 0

    for ($y = $pos[0] - 1; $y -le $pos[0] + 1; $y++) {
        for ($x = $pos[1] - 1; $x -le $pos[1] + 1; $x++) {
            if ($x -lt 0 -or $x -gt ($xx - 1)) { continue }
            if ($y -lt 0 -or $y -gt ($yy - 1)) { continue }
            if ($data[$y][$x] -eq 0) { continue }

            $data[$y][$x] += 1

            if ($data[$y][$x] -gt 9) { Flash $data @($y, $x) }
        }
    }
}

function stillCharged {
    for ($y = 0; $y -lt $yy; $y++) {
        for ($x = 0; $x -lt $xx; $x++) {
            if ($data[$y][$x] -gt 9) { return $true }
        }
    }
    return $false
}

$flashes = 0

for ($step = 1; $step -le 1000000000; $step++) {
    #increment
    for ($y = 0; $y -lt $yy; $y++) {
        for ($x = 0; $x -lt $xx; $x++) {
            [int]$data[$y][$x] += 1
        }
    }

    #get charged
    while ( stillCharged ) {
        $charged = for ($y = 0; $y -lt $yy; $y++) {
            for ($x = 0; $x -lt $xx; $x++) {
                if ($data[$y][$x] -gt 9) { , @($y, $x) }
            }
        }
        if ($charged[0] -is [int]) { $charged = , @($charged[0], $charged[1]) }

        #flash
        $charged | ForEach-Object { Flash $data $_ }
    }

    $stepFlash = ($data | ForEach-Object { $_ | Where-Object { $_ -eq 0 } }).count
    $flashes += $stepFlash

    if ($step -eq 100) { Write-Host "Part 1: $flashes"; Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())" }
    if ($stepFlash -eq 100) { Write-Host "Part 2: $step"; break }
}

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"