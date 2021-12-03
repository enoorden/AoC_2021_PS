Write-Host 'Day2'

[string[]]$data = Get-Content .\02_input.txt

#part1
$pos = 0
$depth = 0

foreach ($d in $data) {
    $action, $amnt = $d.split().trim()
    switch ($action) {
        'forward' { $pos += $amnt }
        'up' { $depth -= $amnt }
        'down' { $depth += $amnt }
    }
}

Write-Host "Part1 : $($pos * $depth)"

#part2
$pos = 0
$depth = 0
$aim = 0

foreach ($d in $data) {
    $action,$amnt = $d.split().trim()
    switch ($action) {
        'forward' { $pos += $amnt; $depth += $aim * $amnt }
        'up' { $aim -= $amnt }
        'down' { $aim += $amnt }
    }
}

Write-Host "Part2 : $($pos * $depth)"