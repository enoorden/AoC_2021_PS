$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day15'

if ($data) { Remove-Variable data }
$data = (Get-Content .\15_input.txt) | ForEach-Object { , [int[]]@($_ -split '' | Where-Object { $_ }) }

$xx = $data[0].Length
$yy = $data.Length

$s = foreach ($i in 1..$yy) { , (, 99999 * $xx) }

function get-neighbours($x, $y, $vx, $vy) {
    $n = @()
    if ($x -gt 0) { $n += , @(($x - 1), $y) }
    if ($x -lt ($xx - 1)) { $n += , @(($x + 1), $y) }
    if ($y -gt 0) { $n += , @($x, ($y - 1)) }
    if ($y -lt ($yy - 1)) { $n += , @($x, ($y + 1)) }
    $n
}

$s[0][0] = 0

for ($y = 0; $y -lt $yy; $y++) {
    for ($x = 0; $x -lt $xx; $x++) {
        foreach ($n in get-neighbours $x $y) {
            $cost = $data[$n[1]][$n[0]] + $s[$y][$x]
            if ($s[$n[1]][$n[0]] -gt $cost) { $s[$n[1]][$n[0]] = $cost }
        }
    }
}

Write-Host 'part1:'$s[-1][-1]
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"

#region multiply field
$data = (Get-Content .\15_input.txt) | ForEach-Object { , [int[]]@($_ -split '' | Where-Object { $_ }) }
$d = foreach ($i in 1..$yy * 5) { , (, 0 * $xx * 5) }

for ($y = 0; $y -lt $d[0].count; $y++) {
    for ($x = 0; $x -lt $data.count; $x++) {
        $n = $data[$y % $yy][$x] + (([math]::floor($y / $yy)))
        $d[$y][$x] = $n % 10 + [math]::floor($n / 10)
    }
}

for ($y = 0; $y -lt $d[0].count; $y++) {
    for ($x = $xx; $x -lt $d.count; $x++) {
        $n = $d[$y][$x % $xx] + (([math]::floor($x / $xx)))
        $d[$y][$x] = $n % 10 + [math]::floor($n / 10)
    }
}

#endregion


$xx = $d[0].Length
$yy = $d.Length

$s = foreach ($i in 1..$yy) { , (, 9999 * $xx) }
$s[0][0] = 0

1..3 | ForEach-Object {
    for ($y = 0; $y -lt $yy; $y++) {
        for ($x = 0; $x -lt $xx; $x++) {
            foreach ($n in get-neighbours $x $y) {
                $cost = $d[$n[1]][$n[0]] + $s[$y][$x]
                if ($cost -lt $s[$n[1]][$n[0]]) { $s[$n[1]][$n[0]] = $cost }
            }
        }
    }
}
Write-Host 'part2:'$s[-1][-1]
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"