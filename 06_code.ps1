Write-Host 'Day6'

[System.Int32[]]$inputNrs = (Get-Content .\06_input.txt) -split ','
$data = [System.Collections.Generic.List[int]]::new()
$data.AddRange($inputNrs)

$days = 80

function fishRate($age, $days) {
    $d = [System.Collections.Generic.List[int]]::new()
    $d.Add(0)
    1..($days - $age) | ForEach-Object {
        for ($i = 0; $i -lt $d.Count; $i++) { $d[$i]-- }
        $resets = $d.RemoveAll({ $args[0] -eq -1 })
        $d.AddRange([System.Int32[]]@(6,8)*$resets)
    }
    $d.Count
}

$dic = @{}
foreach ($d in ($data | Select-Object -Unique)) {
    $dic.$d = fishRate $d $days
}

($data | % { $dic.$_ } | Measure-Object -Sum).sum
