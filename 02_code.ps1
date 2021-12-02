Write-Host 'Day2'

$data = Get-Content .\02_input.txt

#part1
$pos = 0
$depth = 0

foreach ($d in $data) {
    $action,$i = $d.split().trim()
    switch ($action) {
        'forward' { $pos += $i }
        'up' { $depth -= $i }
        'down' { $depth += $i }
    }
}

Write-Host "Part1 : $($pos * $depth)"

#part2
$pos = 0
$depth = 0
$aim = 0

foreach ($d in $data) {
    $action,$i = $d.split().trim()
    switch ($action) {
        'forward' { $pos += $i; $depth += $aim * $i }
        'up' { $aim -= $i }
        'down' { $aim += $i }
    }
}

Write-Host "Part2 : $($pos * $depth)"