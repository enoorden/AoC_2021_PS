$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day14'

if ($data) { Remove-Variable data }
$data = (Get-Content .\14_input.txt)

$tmp = $data[0]

$rules = @{}
$data[2..($data.Length - 1)] | ForEach-Object {
    $e, $i = $_.split(' -> ')
    $rules.$e = $i
}


1..10 | ForEach-Object {
    $ins = @{}
    foreach ($k in $rules.Keys) {
        $index = -1
        do {
            $index = $tmp.IndexOf($k, $index + 1)
            if ($index -ge 0) { $ins[($index + 1)] = $rules.$k }
        } while ($index -ge 0)
    }

    $loop = 0
    ($ins.GetEnumerator() | Sort-Object Name) | ForEach-Object {
        $tmp = $tmp.Insert(($_.Key + $loop), $_.Value)
        $loop++
    }
}

$grp = [char[]]$tmp | Group-Object | Sort-Object count -Descending
$grp[0].count - $grp[-1].count