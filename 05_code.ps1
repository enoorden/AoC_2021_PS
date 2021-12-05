Write-Host 'Day5'

[string[]]$data = Get-Content .\05_input.txt

$grid = New-Object 'int[,]' 1000, 1000

foreach ($d in $data) {
    $x1, $y1, $x2, $y2 = $d -split ' -> ' -split ','
    if ($x1 -eq $x2) { $y1..$y2 | ForEach-Object { $grid[$x1, $_] += 1 } }
    elseif ($y1 -eq $y2) { $x1..$x2 | ForEach-Object { $grid[$_, $y1] += 1 } }
}
($grid | Where-Object { $_ -gt 1 }).count



$grid = New-Object 'int[,]' 1000, 1000
foreach ($d in $data) {
    $x1, $y1, $x2, $y2 = $d -split ' -> ' -split ','
    if ($x1 -eq $x2) { $y1..$y2 | ForEach-Object { $grid[$x1, $_] += 1 } }
    elseif ($y1 -eq $y2) { $x1..$x2 | ForEach-Object { $grid[$_, $y1] += 1 } }
    else {
        $ln = [System.Math]::Abs($x1 - $x2)
        0..$ln | ForEach-Object {
            $grid[($x1..$x2)[$_], ($y1..$y2)[$_]] += 1
        }
    }
}
($grid | Where-Object { $_ -gt 1 }).count