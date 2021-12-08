$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

function decode($in, $out) {
    $inGrp = $in -split '\s+' | Group-Object { $_.length } -AsHashTable

    $digits = @{
        1 = [string]$ingrp.2
        4 = [string]$ingrp.4
        7 = [string]$ingrp.3
        8 = [string]$ingrp.7
    }

    #5 segments
    $digits.3 = $inGrp.5 | Where-Object { $_ -notin $digits.values } | Where-Object { (Compare-Object ([char[]]($_)) ([char[]][string]$digits.7) -ExcludeDifferent -IncludeEqual).sideIndicator.count -eq 3 }
    $digits.2 = $inGrp.5 | Where-Object { $_ -notin $digits.values } | Where-Object { (Compare-Object ([char[]]($_)) ([char[]][string]$digits.4) -ExcludeDifferent -IncludeEqual).sideIndicator.count -eq 2 }
    $digits.5 = $inGrp.5 | Where-Object { $_ -notin $digits.values }

    #6 segments
    $digits.9 = $inGrp.6 | Where-Object { $_ -notin $digits.values } | Where-Object { (Compare-Object ([char[]]($_)) ([char[]][string]$digits.3) -ExcludeDifferent -IncludeEqual).sideIndicator.count -eq 5 }
    $digits.6 = $inGrp.6 | Where-Object { $_ -notin $digits.values } | Where-Object { (Compare-Object ([char[]]($_)) ([char[]][string]$digits.5) -ExcludeDifferent -IncludeEqual).sideIndicator.count -eq 5 }
    $digits.0 = $inGrp.6 | Where-Object { $_ -notin $digits.values }

    $display = @{}
    $digits.GetEnumerator() | ForEach-Object { $display.(([char[]]$_.Value | Sort-Object) -join '') = $_.key }

    return [int](($out.split() | ForEach-Object { $display[([char[]]$_ | Sort-Object) -join ''] }) -join '')
}


Write-Host 'Day8 PS'

[System.String[]]$data = (Get-Content .\08_input.txt) -split ','
$in = $data | ForEach-Object { (($_ -split '\|')[0]).trim() }
$out = $data | ForEach-Object { (($_ -split '\|')[1]).trim() }

#part1
$regex1478 = '(?:^|\ )(\w{2,4}|\w{7})(?=$|\ )'
Write-Host 'Part1 :' ($out | Select-String -Pattern $regex1478 -AllMatches | ForEach-Object { $_.Matches }).count

#part2
Write-Host 'Part2 :' (0..($data.Length - 1) | ForEach-Object { decode $in[$_] $out[$_] } | Measure-Object -Sum).Sum

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"