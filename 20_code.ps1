$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day20'

function enhancePixel ($x, $y, $dic) {
    $str = ''
    for ($yy = $y - 1; $yy -le $y + 1; $yy++) {
        for ($xx = $x - 1; $xx -le $x + 1; $xx++) {
            if ($xx -ge $global:max -or $yy -ge $global:max -or $xx -le $global:min -or $yy -le $global:min) {
                $str += $global:uneven ? '.' : '#'
            } else {
                $str += $dic.ContainsKey("$xx!$yy") ? $dic["$xx!$yy"] : '.'
            }
        }
    }
    return $algDic[$str]
}

function enhanceImg ($imgDic) {
    $global:min--
    $global:max++
    $enhanced = @{}
    for ($y = $global:min; $y -le $global:max; $y++) {
        for ($x = $global:min; $x -le $global:max; $x++) {
            if ((enhancepixel $x $y $imgDic) -eq '#') { $enhanced["$x!$y"] = '#' }
        }
    }
    return $enhanced
}

if ($data) { Remove-Variable data }
$data = (Get-Content .\20_input.txt)

$algorithm = $data[0]
$img = $data[2..($data.length - 1)]

$algDic = @{}
0..($algorithm.Length - 1) | ForEach-Object {
    $algDic[[System.Convert]::ToString($_, 2).PadLeft(9, '0').Replace(0, '.').Replace(1, '#')] = $algorithm[$_]
}

$global:min = 0
$global:max = $img.Length

$imgDic = @{}
for ($y = 0; $y -lt $img.Length; $y++) {
    for ($x = 0; $x -lt $img.Length; $x++) {
        if ($img[$y][$x] -eq '#') { $imgDic["$x!$y"] = '#' }
    }
}

1..50 | ForEach-Object {
    $global:uneven = $_ % 2 -eq 1 ? $true : $false
    $imgDic = enhanceImg $imgDic

    if ($_ -eq 2) { Write-Host 'Part1 :' $imgDic.count }
}

Write-Host 'Part1 :' $imgDic.count

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"