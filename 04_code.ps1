Write-Host 'Day4'

#[string[]]$data = Get-Content .\04_sample.txt
[string[]]$data = Get-Content .\04_input.txt

[int[]]$nrs = $data[0].split(',').trim()

function checkBingo($card, $nrs) {
    $bingo = $false

    if ($card | Where-Object { (Compare-Object $_ $nrs -IncludeEqual -ExcludeDifferent).count -eq 5 }) { $bingo = $true }

    if (-not $bingo) {
        $cardCol = @()
        for ($i = 0; $i -lt 6; $i++) {
            $cardCol += , @($card | ForEach-Object { $_[$i] | Where-Object { $_ } })
        }

        if ($cardCol | Where-Object { (Compare-Object $_ $nrs -IncludeEqual -ExcludeDifferent).count -eq 5 }) { $bingo = $true }
    }

    if ($bingo) {
        $sum = -split $card | Where-Object { $_ -notin $nrs } | Measure-Object -Sum

        return $sum.Sum * $nrs[-1]
    }

    $false
}

$cards = @{}
$c = 0
for ($i = 1; $i -lt $data.Length; $i++) {
    if ([string]::isNullOrEmpty($data[$i])) { $c++; $cards.$c = @(); continue }
    $cards.$c += , @($data[$i].trim() -split '\s+')
}

$completed = @()
5..100 | ForEach-Object {
    $i = $_
    $cards.GetEnumerator() | ForEach-Object {
        if ($_.key -notin $completed) {
            $res = checkBingo $_.Value $nrs[0..$i]
            if ($res) {
                $completed += $_.key
                Write-Host "round $I - $res"
            }
        }
    }
}
