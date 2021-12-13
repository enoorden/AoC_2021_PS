$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day12'

function findPath($map, $start, $visited, $path, $doubleVisit) {
    if ($start -eq 'end') { return $path }

    $path += "$start - "
    if ($start -cmatch '[a-z]' -and $start -notin $visited) {
        if ($doubleVisit -and $start -eq $doubleVisit) {
            $doubleVisit = $null #skip the double visit once
        } else {
            $visited += $start
        }
    }

    foreach ($dir in ($map.$start | Where-Object { $_ -notin $visited })) {
        findPath $map $dir $visited $path $doubleVisit
    }
}

if ($data) { Remove-Variable data }
$data = (Get-Content .\12_input.txt)

$map = @{}
foreach ($d in $data) {
    , @($d.split('-')) | ForEach-Object {
        $map."$($_[0])" += , $_[1]
        $map."$($_[1])" += , $_[0]
    }
}

#Part1
$paths = findPath $map 'start' $visited
Write-Host 'Part8 1:' $paths.count
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"

#Part2
$smallCaves = $data.split('-') | Where-Object { $_ -cmatch '^(?:(?!start|end))[a-z].*' } | Select-Object -Unique

$paths = @()
foreach ($c in $smallCaves) {
    $paths += findPath $map 'start' $visited $path $c
}

Write-Host 'Part 2:' ($paths | Group-Object | Measure-Object).count

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"