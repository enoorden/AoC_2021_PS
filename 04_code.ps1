Write-Host 'Day4'

#[string[]]$data = Get-Content .\04_sample.txt
[string[]]$data = Get-Content .\04_input.txt

[int[]]$nrs = $data[0].split(',').trim()


function checkBingo {
    param($card, $nrs)
    $bingo = $false

    if ($card | Where-Object { (Compare-Object $_ $nrs -IncludeEqual -ExcludeDifferent).count -eq 5 }) { $bingo = $true }

    $cardCol = @()
    for ($i = 0; $i -lt 6; $i++) {
        $cardCol += , @($card | ForEach-Object { $_[$i] | Where-Object { $_ } })
    }

    if ($cardCol | Where-Object { (Compare-Object $_ $nrs -IncludeEqual -ExcludeDifferent).count -eq 5 }) { $bingo = $true }

    if ($bingo) {
        $sum = $card | ForEach-Object { ($_ | Where-Object { $_ -notin $nrs } | Measure-Object -Sum).sum } | Measure-Object -Sum

        return $sum.sum * $nrs[-1]
    }

    $false
}

$cards = @{}
$c = 0
for ($i = 1; $i -lt $data.Length; $i++) {
    if ([string]::isNullOrEmpty($data[$i])) { $c++; $cards.$c = @(); continue }
    $cards.$c += , @($data[$i].trim() -split '\s+')
}

0..100 | ForEach-Object {
    $i = $_
    Write-Host "Round $i"
    $cards.GetEnumerator() | ForEach-Object {
        $res = checkBingo $_.Value $nrs[0..$i]
        if ($res) {
            $cards.Remove($_.key)
            Write-Host "round $I - $res"
        }
    }

}

#checkBingo $cards[1] $nrs