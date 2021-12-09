$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

[System.String[]]$data = (Get-Content .\09_input.txt)


#part1

#part2

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"