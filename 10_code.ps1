$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day10'

[string[]]$data = (Get-Content .\10_input.txt) -split ','

$pairs = @{
    ')' = '('
    ']' = '['
    '}' = '{'
    '>' = '<'
}

$pairsClosing = @{
    '(' = ')'
    '[' = ']'
    '{' = '}'
    '<' = '>'
}

$score = @{
    ')' = 3
    ']' = 57
    '}' = 1197
    '>' = 25137
}

$scoreComplete = @{
    ')' = 1
    ']' = 2
    '}' = 3
    '>' = 4
}

function getillegalchar($str, $complete = $false) {
    $stack = [System.Collections.Generic.List[char]]::new()

    foreach ($c in [char[]]$str) {
        if ($c -in $pairs.Values) {
            $stack.Add($c)
        } elseif ($c -in $pairs.Keys) {
            if ($pairs."$c" -eq $stack[-1]) {
                $stack.RemoveAt($stack.count - 1)
            } else {
                if (-not $complete) { return $c }
                else { return }
            }
        }
    }

    if ($stack.Count -eq 0) { return }

    if ($complete) {
        $stack.Reverse()
        return ($stack | ForEach-Object { $pairsClosing."$_" }) -join ''
    }
}

#Part1
Write-Host 'Part 1:' ($data | ForEach-Object { $score."$(getillegalchar $_)" } | Measure-Object -Sum).Sum

#Part2
$scoreCompleteTotal = @()
$data | ForEach-Object { getillegalchar $_ -complete $true } | ForEach-Object {
    $lineScore = 0
    [char[]]$_ | ForEach-Object {
        $lineScore *= 5
        $lineScore += $scoreComplete."$_"
    }
    $scoreCompleteTotal += $lineScore
}

$scoreCompleteTotal = $scoreCompleteTotal | Sort-Object
Write-Host 'Part 2:' $scoreCompleteTotal[[Math]::Floor($scoreCompleteTotal.count / 2)]

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"