$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day12'
$results = [System.Collections.Generic.HashSet[string]]::new()
function findPath($map, $start = 'start', $visited = @(), $path, $doubleVisit) {
    if ($start -eq 'end') {
        $null = $results.Add($path)
        return
    }

    $path += $start
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

    return
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
findPath $map 'start'
Write-Host 'Part 1:' $results.count
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"

#Part2
$smallCaves = $data.split('-') | Where-Object { $_ -cmatch '^(?:(?!start|end))[a-z].*' } | Select-Object -Unique

$results.Clear()
foreach ($c in $smallCaves) {
    findPath $map 'start' -doubleVisit $c
}

Write-Host 'Part 2:' $results.count

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"