$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

$input17 = 'target area: x=185..221, y=-122..-74'

$r = [Regex]::new('^.*x=(-?\d+)\.\.(-?\d+).*y=(-?\d+)..(-?\d+)$')
$x1, $x2, $y1, $y2 = $r.Matches($input17).groups[1..4].value
$target = @{
    x1 = ($x1, $x2 | Measure-Object -Minimum).Minimum
    x2 = ($x1, $x2 | Measure-Object -Maximum).Maximum
    y1 = ($y1, $y2 | Measure-Object -Maximum).Maximum
    y2 = ($y1, $y2 | Measure-Object -Minimum).Minimum
}


function shoot($x, $y, $target = $target) {
    $orgx = $x
    $orgy = $y
    $maxY = 1
    $trjX = 0
    $trjY = 0
    do {
        $trjX += $x
        $trjY += $y
        $x -= $x -gt 0 ? 1 : 0
        $y -= 1
        if ($y -eq 0) { $maxY = $trjY }
        if ($trjX -ge $target.x1 -and $trjX -le $target.x2 -and $trjY -le $target.y1 -and $trjY -ge $target.y2) { return $maxy }
    } until ($trjX -gt $target.x2 -or $trjY -lt $target.y2)
    return $false
}

$hits = @()
0..($target.x2) | ForEach-Object {
    $x = $_
    ($target.y2)..([math]::Abs($target.y2)) | ForEach-Object {
        $y = $_
        if ($max = shoot $x $y $target) { $hits += $max }
    }
}

$stats = $hits | Measure-Object -AllStats
Write-Host 'Part1:' $stats.Maximum
Write-Host 'Part2:' $stats.Count

Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"