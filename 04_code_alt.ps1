#faster version using regex matching

$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day4 - Regex'

[string[]]$data = Get-Content .\04_input.txt

[string[]]$nrs = $data[0].split(',').trim() -replace '^(\d{1})$', '0$1'

[string[]]$cards = for ($i = 2; $i -lt $data.Count; $i += 6) {
    $data[$i..($i + 4)] -join ' ' -replace '\ (\d{1})(?:\ |$)', '0$1 '
}

$bingoRegex = '(^.{0}|^.{15}|^.{30}|^.{45}|^.{60})(?:__\ |__$){5}|(?:__\ .{1,2}\ .{1,2}\ .{1,2}\ .{1,2}\ ){4}__'

$bingos= @()
foreach ($nr in $nrs) {
    $cards = $cards -replace $nr, '__'
    $bingos += $cards -match $bingoRegex | ForEach-Object {
        ([int[]]($_ | Select-String -Pattern '(\d+)' -All | ForEach-Object { $_.matches }).value | Measure-Object -Sum).Sum * [int]$nr
    }
    $cards = $cards -notmatch $bingoRegex
}

$bingos | Select -First 1
$bingos | Select -Last 1

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"