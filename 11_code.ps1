if ($data) { Remove-Variable data }
$data = (Get-Content .\11_input.txt) | ForEach-Object { , [int[]]@($_ -split '' | Where-Object { $_ }) }
$yy = $data.Length - 1
$xx = $data[0].Length - 1

function chargeAround($data, $pos) {
    if ($data[$pos[0]][$pos[1]] -eq 0) { return }
    $data[$pos[0]][$pos[1]] = 0
    ($pos[0] - 1)..($pos[0] + 1) | ForEach-Object {
        $y = $_
        ($pos[1] - 1)..($pos[1] + 1) | ForEach-Object {
            $x = $_
            if ($x -lt 0 -or $x -gt $xx) { return }
            if ($y -lt 0 -or $y -gt $yy) { return }
            if ($data[$y][$x] -eq 0) { return }

            $data[$y][$x] += 1

            if ($data[$y][$x] -gt 9) { chargeAround $data @($y, $x) }
        }
    }
}

$flashes = 0

#get positions which should flash
for ($step = 1; $step -le 1000000000; $step++) {
    #increment
    for ($y = 0; $y -lt $data.Length; $y++) {
        for ($x = 0; $x -lt ($data[0].Length); $x++) {
            [int]$data[$y][$x] += 1
        }
    }

    #get charged
    while ( $data | ForEach-Object { $_ | Where-Object { $_ -gt 9 } }) {
        $charged = for ($y = 0; $y -lt $data.Length; $y++) {
            for ($x = 0; $x -lt $data[0].Length; $x++) {
                if ($data[$y][$x] -gt 9) { , @($y, $x) }
            }
        }
        if ($charged[0] -is [int]) { $charged = , @($charged[0], $charged[1]) }

        $charged | ForEach-Object { chargeAround $data $_ }
    }

    $stepFlash = ($data | ForEach-Object { $_ | Where-Object { $_ -eq 0 } }).count
    $flashes += $stepFlash

    if ($step -eq 100) { Write-Host "Part 1: $flashes" }
    if ($stepFlash -eq 100) { Write-Host "Part 2: $step"; break }
}