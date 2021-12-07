Write-Host 'Day7'

[System.Int32[]]$data = (Get-Content .\07_input.txt) -split ','

#Part1
$results = @{}
1..$data.Count | ForEach-Object {
    $align = $_
    $fuel = 0

    0..($data.Count - 1) | ForEach-Object {
        $fuel += [math]::Abs($align - $data[$_])
    }

    $results.$align = $fuel
}

Write-Host 'Part1:'
$results.GetEnumerator() | Sort-Object Value | Select-Object -First 1

#Part2
$results = @{}
1..$data.Count | ForEach-Object {
    $align = $_
    $fuel = 0

    0..($data.Count - 1) | ForEach-Object {
        $steps = [math]::Abs($align - $data[$_])
        $fuel += $steps * (($steps / 2) + 0.5)
    }

    $results.$align = $fuel
}

Write-Host 'Part2:'
$results.GetEnumerator() | Sort-Object Value | Select-Object -First 1