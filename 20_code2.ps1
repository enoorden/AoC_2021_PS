$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day20'

if ($data) { Remove-Variable data }
$data = (Get-Content .\20_input.sample.txt)

$algorithm = $data[0]

function enhancePixel ($x, $y, $dic) {
    $str = ''
    for ($yy = $y - 1; $yy -le $y + 1; $yy++) {
        for ($xx = $x - 1; $xx -le $x + 1; $xx++) {
            $str += $dic["$xx-$yy"]
        }
    }

    $strBin = $str.Replace('.', 0).Replace('#', 1)

    $int = [Convert]::ToInt32($strBin, 2)
    return $algorithm[$int] -eq '#' ? '#' : '.'
}

function enhanceImg ($imgDic, $length) {
    $enhanced = @{}
    for ($y = 0; $y -lt $Length; $y++) {
        for ($x = 0; $x -lt $Length; $x++) {
            $enhanced["$x-$y"] = enhancepixel $x $y $imgDic
        }
    }
    return $enhanced
}

$img = $data[2..($data.length - 1)]

#grow image.. to infinity!! 5 infinity on all sides!
$grow = 50
for ($i = 0; $i -lt $img.Count; $i++) { $img[$i] = '.' * $grow + $img[$i] + '.' * $grow }
$img = @('.' * $img[0].Length) * $grow + $img + @('.' * $img[0].Length) * $grow

$imgDic = @{}
for ($y = 0; $y -lt $img.Length; $y++) {
    for ($x = 0; $x -lt $img.Length; $x++) {
        $imgDic["$x-$y"] = $img[$y][$x]
    }
}

1..50 | ForEach-Object {
    Write-Host $_; $imgDic = enhanceImg $imgDic $img.Length

    if ($_ % 10 -eq 0) {
        for ($y = 2; $y -lt $img.Length - 2; $y++) {
            for ($x = 2; $x -lt $img.Length - 2; $x++) {
                Write-Host $imgDic["$x-$y"] -NoNewline
            }
            Write-Host
        }
    }
}

$count = 0
for ($y = 2; $y -lt $img.Length - 2; $y++) {
    for ($x = 2; $x -lt $img.Length - 2; $x++) {
        if ( $imgDic["$x-$y"] -eq '#') { $count++ }
    }
}
$count
exit



$dic = @{}
for ($y = 0; $y -lt $img.Length; $y++) {
    for ($x = 0; $x -lt $img.Length; $x++) {
        $dic["$x-$y"] = enhancepixel $x $y $orgDic
    }
}

$dic.values | Where-Object { $_ -eq '#' } | Measure-Object

$dic2 = @{}
for ($y = 0; $y -lt $img.Length; $y++) {
    for ($x = 0; $x -lt $img.Length; $x++) {
        $dic2["$x-$y"] = enhancepixel $x $y $dic
    }
}
$dic2.values | Where-Object { $_ -eq '#' } | Measure-Object

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"


$count = 0
for ($y = 2; $y -lt $img.Length - 2; $y++) {
    for ($x = 2; $x -lt $img.Length - 2; $x++) {
        if ( $dic2["$x-$y"] -eq '#') { $count++ }
    }
}
$count


#6088 too high