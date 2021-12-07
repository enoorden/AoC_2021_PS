$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day7 PS'

[System.Int32[]]$data = (Get-Content .\07_input.txt) -split ','

#Part1
$lowest = [int]::MaxValue

1..$data.Count | ForEach-Object {
    $align = $_
    $fuel = 0

    0..($data.Count - 1) | ForEach-Object {
        $fuel += [math]::Abs($align - $data[$_])
    }

    if ($fuel -lt $lowest) { $lowest = $fuel }
}

Write-Host "Part1 : $lowest"
#$results.GetEnumerator() | Sort-Object Value | Select-Object -First 1

#Part2
$lowest = [int]::MaxValue

1..$data.Count | ForEach-Object {
    $align = $_
    $fuel = 0

    0..($data.Count - 1) | ForEach-Object {
        $steps = [math]::Abs($align - $data[$_])
        $fuel += $steps * (($steps / 2) + 0.5)
    }

    if ($fuel -lt $lowest) { $lowest = $fuel }
}

Write-Host "Part2 : $lowest"

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"
