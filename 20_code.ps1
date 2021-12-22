$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day20'

if ($data) { Remove-Variable data }
$data = (Get-Content .\20_input.txt)

$algorithm = $data[0]
function enhance ($str) {
    $int = [Convert]::ToInt32($str, 2)
    return $algorithm[$int] -eq '#' ? 1 : 0
}

function enhancepixel ($x, $y, $img) {
    $str = ''
    for ($yy = $y - 1; $yy -le $y + 1; $yy++) {
        for ($xx = $x - 1; $xx -le $x + 1; $xx++) {
            $str += $img[$yy][$xx]
        }
    }

    $strBin = $str.Replace('.', 0).Replace('#', 1)

    $int = [Convert]::ToInt32($strBin, 2)
    return $algorithm[$int] -eq '#' ? '#' : '.'
}

$img = $data[2..($data.length - 1)]

#grow image.. to infinity!!
$grow = 5
for ($i = 0; $i -lt $img.Count; $i++) { $img[$i] = '.' * $grow + $img[$i] + '.' * $grow }
$img = @('.' * $img[0].Length) * $grow + $img + @('.' * $img[0].Length) * $grow

$dic = @{}
for ($y = 2; $y -lt $img.Length - 4; $y++) {
    for ($x = 2; $x -lt $img.Length - 4; $x++) {
        $dic["$x-$y"] = enhancepixel $x $y $img
    }
}









