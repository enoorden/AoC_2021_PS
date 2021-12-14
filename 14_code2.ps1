$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day14'

if ($data) { Remove-Variable data }
$data = (Get-Content .\14_input.txt)

$tmp = $data[0]

$rules = @{}
$data[2..($data.Length - 1)] | ForEach-Object {
    $e, $i = $_.split(' -> ')
    $rules.$e = @{
        insert   = $i
        newPairs = @(($e[0] + $i), ($i + $e[1]))
    }
}
function processPolymer($template, $rules, $steps) {
    $chars = @{}
    [char[]]$template | Group-Object | ForEach-Object { $chars.($_.Name) = $_.Count }

    $pairs = @{}
    $pairCount = for ($i = 0; $i -lt $template.Length - 1; $i++) { $template.Substring($i, 2) }
    $pairCount | Group-Object | ForEach-Object { $pairs.($_.Name) = $_.Count }

    1..$steps | ForEach-Object {
        $newPairs = @{}
        foreach ($p in $pairs.GetEnumerator()) {
            $chars.(($rules.($p.Key)).insert) += $p.value
            ($rules.($p.Key)).newPairs | ForEach-Object { $newPairs.$_ += $p.Value }
        }
        $pairs = $newPairs
    }

    $chars
}

$chars = processPolymer -steps 10 -rules $rules -template $tmp
$sorted = $chars.GetEnumerator() | Sort-Object Value -Descending
Write-Host "Part1:" ($sorted[0].Value - $Sorted[-1].Value)

$chars = processPolymer -steps 40 -rules $rules -template $tmp
$sorted = $chars.GetEnumerator() | Sort-Object Value -Descending
Write-Host "Part1:" ($sorted[0].Value - $Sorted[-1].Value)

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"