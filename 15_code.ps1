$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day15'

if ($data) { Remove-Variable data }
$data = (Get-Content .\15_input.txt) | ForEach-Object { , [int[]]@($_ -split '' | Where-Object { $_ }) }

$xx = $data[0].Length
$yy = $data.Length

$s = foreach ($i in 1..$yy) { , (, 0 * $xx) }

for ($y = 1; $y -lt $yy; $y++) {
    $s[$y][0] = $s[$y - 1][0] + $data[$y][0]
}

for ($x = 1; $x -lt $yy; $x++) {
    $s[0][$x] = $s[0][$x - 1] + $data[0][$x]
}


for ($y = 1; $y -lt $yy; $y++) {
    for ($x = 1; $x -lt $xx; $x++) {
        $s[$y][$x] = [math]::Min( $data[$y][$x] + $s[$y - 1][$x], $data[$y][$x] + $s[$y][$x - 1] )

    }
}

write-host "part1:"$s[-1][-1]
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"

#$data
#$data | ForEach-Object { $_ -join '' }

#region multiply field
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

$s = foreach ($i in 1..$yy) { , (, 0 * $xx) }

for ($y = 1; $y -lt $yy; $y++) {
    $s[$y][0] = $s[$y - 1][0] + $d[$y][0]
}

for ($x = 1; $x -lt $yy; $x++) {
    $s[0][$x] = $s[0][$x - 1] + $d[0][$x]
}

for ($y = 1; $y -lt $yy; $y++) {
    for ($x = 1; $x -lt $xx; $x++) {
        $s[$y][$x] = [math]::Min( $d[$y][$x] + $s[$y - 1][$x], $d[$y][$x] + $s[$y][$x - 1] )
    }
}
write-host "part2:"$s[-1][-1]
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"
