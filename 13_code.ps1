$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day13'

if ($data) { Remove-Variable data }
$data = (Get-Content .\13_input.txt)

$paper = $data | Where-Object { $_ -match '\d,\d' } | ForEach-Object { , [int[]]@($_ -split ',') }
$folds = $data | ForEach-Object { $_ | Select-String '^fold.*((y|x)=\d*)$' } | ForEach-Object { $_.matches.groups[1].value } | ForEach-Object { , @($_ -split '='  ) }

$stars = @()
foreach ($fold in $folds) {
    $axe = $fold[0] -eq 'x' ? 0 : 1
    $line = [int]$fold[1]
    for ($s = 0; $s -lt $paper.Count; $s++) {
        if ($paper[$s][$axe] -gt $line ) { $paper[$s][$axe] = $line - ($paper[$s][$axe] - $line ) }
    }
    $stars += ($paper | ForEach-Object { $_ -join ',' } | Group-Object | Measure-Object).Count
}
Write-Host 'Part1:' $stars[0]

Write-Host "`npart2:"
$strPaper = $paper | ForEach-Object { $_ -join ',' }

$yy = ($Paper | ForEach-Object { $_[1] } | Measure-Object -max).maximum
$xx = ($Paper | ForEach-Object { $_[0] } | Measure-Object -max).maximum
for ($y = 0; $y -le $yy; $y++) {
    for ($x = 0; $x -le $xx; $x++) {
        if ("$x,$y" -in $strPaper) { Write-Host '#' -NoNewline }
        else { Write-Host ' ' -NoNewline }
    }
    Write-Host
}

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"