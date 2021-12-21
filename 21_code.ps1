$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day 21 PS'

$global:die = 0
$global:rolls = 0
function roll {
    $roll = (++$global:die, ++$global:die, ++$global:die)
    if ($global:die -ge 100) {
        $global:die -= 100
        0..2 | ForEach-Object { $roll[$_] = $roll[$_] -gt 100 ? $roll[$_] - 100 : $roll[$_] }
    }
    $global:rolls += 3
    return $roll[0] + $roll[1] + $roll[2]
}

function game($p1, $p2) {
    if ($p1[1] -ge 1000) { return $p2 }
    if ($p2[1] -ge 1000) { return $p1 }
    $p1[0] = ($p1[0] + (roll) - 1) % 10 + 1
    $p1[1] += $p1[0]
    game $p2 $p1
}

$loser = game @(9, 0) @(10, 0)

Write-Host 'part1:' ($rolls * $loser[1])
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"



#part2
$rolls = @{ 3 = 1; 4 = 3; 5 = 6; 6 = 7; 7 = 6; 8 = 3; 9 = 1 }

$cache = @{}

function game2($p1pos, $p2pos, $p1score, $p2score) {
    if ($p1score -ge 21) { return @(1, 0) }
    if ($p2score -ge 21) { return @(0, 1) }

    $key = $p1pos, $p2pos, $p1score, $p2score -join '_'
    if ($cache.ContainsKey($key)) { return $cache[$key] }

    [long[]]$totalWins = 0, 0

    foreach ($r in $rolls.GetEnumerator()) {
        $p1posNew = ($p1pos + $r.Key - 1) % 10 + 1
        $p1scoreNew = $p1score + $p1posNew
        $wins = game2 $p2pos $p1posNew $p2score $p1scoreNew

        $totalWins[0] += $wins[1] * $r.value
        $totalWins[1] += $wins[0] * $r.value
    }

    $cache[$key] = $totalWins

    return $totalWins
}

Write-Host 'Part2:' (game2 9 10 0 0 | Sort-Object -Descending -Top 1)

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"