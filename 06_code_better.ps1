Write-Host 'Day 6, better...'
#had some help here!!

[System.Int32[]]$data = (Get-Content .\06_input.txt) -split ','

$days = 256

$c = @{}
$data | Group-Object | ForEach-Object { $c.([int]$_.Name) = $_.Count }

1..$days | ForEach-Object {
    $reset = $c.0
    0..7 | ForEach-Object { $c.$_ = $c.($_ + 1) }
    $c.6 += $reset
    $c.8 = $reset
}

($c.values | Measure-Object -Sum).Sum