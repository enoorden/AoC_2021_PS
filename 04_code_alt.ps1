Write-Host 'Day4'

#[string[]]$data = Get-Content .\04_sample.txt
[string[]]$data = Get-Content .\04_input.txt

[int[]]$nrs = $data[0].split(',').trim()

function checkBingo($card, $nr) {
    $card.replace($nr, '_')
}

$cards = @{}
$c = 0
for ($i = 1; $i -le $data.Length; $i++) {
    if ([string]::isNullOrEmpty($data[$i])) { $cards.$c += '|'; $c++; $cards.$c = ''; continue }
    $cards.$c += '|' + $data[$i].trim() -split '\s+' -join '|'
}
$cards.Remove(0)
$cards.Remove(101)



0..50 | ForEach-Object {
    $i = $_
    1..100 | ForEach-Object {
        $cards.$_ = $cards.$_.replace("|$($nrs[$i])|", '|_|')
    }
}

$cards
