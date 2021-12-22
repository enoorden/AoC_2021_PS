$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day20'



function enhancePixel ($x, $y, $dic) {
    $str = ''
    for ($yy = $y - 1; $yy -le $y + 1; $yy++) {
        for ($xx = $x - 1; $xx -le $x + 1; $xx++) {
            $str += $dic.ContainsKey("$xx!$yy") ? $dic["$xx!$yy"] : '.'
            #$str += $dic.ContainsKey("$xx!$yy") ? $dic["$xx!$yy"] : $global:uneven ? '.' : '#'
        }
    }
    return $algDic[$str]
}

function enhanceImg ($imgDic) {
    $stats = $imgdic.keys.split('!') | Measure-Object -Minimum -Maximum
    $min = $stats.Minimum - 1
    $max = $stats.Maximum + 1

    $enhanced = @{}
    for ($y = $min; $y -le $max; $y++) {
        for ($x = $min; $x -le $max; $x++) {
            if ((enhancepixel $x $y $imgDic) -eq '#') { $enhanced["$x!$y"] = '#' }
        }
    }
    return $enhanced
}


if ($data) { Remove-Variable data }
$data = (Get-Content .\20_input.txt)
#$data = (Get-Content .\20_input.sample.txt)

$algorithm = $data[0]
$algDic = @{}
0..($algorithm.Length - 1) | ForEach-Object {
    $algDic[[System.Convert]::ToString($_, 2).PadLeft(9, '0').Replace(0, '.').Replace(1, '#')] = $algorithm[$_]
}

$img = $data[2..($data.length - 1)]


# $grow = 5
# for ($i = 0; $i -lt $img.Count; $i++) { $img[$i] = '.' * $grow + $img[$i] + '.' * $grow }
# $img = @('.' * $img[0].Length) * $grow + $img + @('.' * $img[0].Length) * $grow


$imgDic = @{}
for ($y = 0; $y -lt $img.Length; $y++) {
    for ($x = 0; $x -lt $img.Length; $x++) {
        if ($img[$y][$x] -eq '#') { $imgDic["$x!$y"] = '#' }
    }
}

$stats = ($imgdic.GetEnumerator() | Where-Object { $_.value -eq '#' }).name.split('!') | Measure-Object -AllStats
$min = $stats.Minimum - 2
$max = $stats.Maximum + 4
for ($y = $min; $y -lt $max; $y++) {
    for ($x = $min; $x -lt $max; $x++) {
        if ($x -eq 0 -and $y -eq 0) {
            if ($imgDic.ContainsKey("$x!$y")) { Write-Host '#' -fo red -NoNewline }
            else { Write-Host '.' -fo red -NoNewline }
        } else {

            if ($imgDic.ContainsKey("$x!$y")) { Write-Host '#' -NoNewline }
            else { Write-Host '.' -NoNewline }
        }
    }
    Write-Host
}

1..50 | ForEach-Object {
    $global:uneven = $_ % 2 -eq 1 ? $true : $false

    Write-Host "$_ $($global:uneven)"
    Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"
    $imgDic = enhanceImg $imgDic



    # $stats = ($imgdic.GetEnumerator() | Where-Object { $_.value -eq '#' }).name.split('!') | Measure-Object -AllStats
    # $min = $stats.Minimum - 2
    # $max = $stats.Maximum + 4
    # for ($y = $min; $y -lt $max; $y++) {
    #     for ($x = $min; $x -lt $max; $x++) {
    #         if ($x -eq 0 -and $y -eq 0) {
    #             if ($imgDic.ContainsKey("$x!$y")) { Write-Host '#' -fo red -NoNewline }
    #             else { Write-Host '.' -fo red -NoNewline }
    #         } else {

    #             if ($imgDic.ContainsKey("$x!$y")) { Write-Host '#' -NoNewline }
    #             else { Write-Host '.' -NoNewline }
    #         }
    #     }
    #     Write-Host
    # }

}

$imgDic.count

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"


#20122