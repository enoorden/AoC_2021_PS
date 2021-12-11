if ($data) { Remove-Variable data }
$data = (Get-Content .\11_input.txt) | ForEach-Object { , [int[]]@($_ -split '' | Where-Object { $_ }) }
$yy = $data.Length - 1
$xx = $data[0].Length - 1

# for ($step = 0; $step -lt 100; $step++) {
#     do {
#         for ($y = 0; $y -lt $data.Length; $y++) {
#             for ($x = 0; $x -lt ($data[0].Length); $x++) {
#                 if ($y -gt 0) { if ($data[$y - 1][$x] -like 'B*') { $data[$y][$x] = $data[$y - 1][$x] } }
#                 if ($y -lt $data.Length - 1) { if ($data[$y + 1][$x] -like 'B*') { $data[$y][$x] = $data[$y + 1][$x] } }
#                 if ($x -gt 0) { if ($data[$y][$x - 1] -like 'B*') { $data[$y][$x] = $data[$y][$x - 1] } }
#                 if ($x -lt $data[0].Length) { if ($data[$y][$x + 1] -like 'B*') { $data[$y][$x] = $data[$y][$x + 1] } }
#             }
#         }
#     } while ($data | ForEach-Object { $_ | Where-Object { $_ -notlike 'B*' -and $_ -ne 9 } })
# }


function chargeAround($data, $pos) {
    #$data[$pos[0]][$pos[1]] -= 1
    $data[$pos[0]][$pos[1]] = 0
    ($pos[0] - 1)..($pos[0] + 1) | ForEach-Object {
        $y = $_
        ($pos[1] - 1)..($pos[1] + 1) | ForEach-Object {
            $x = $_
            if ($x -lt 0 -or $x -gt $xx) { return }
            if ($y -lt 0 -or $y -gt $yy) { return }
            if ($data[$y][$x] -eq 0) { return }
            $data[$y][$x] += 1
            if ($data[$y][$x] -gt 9) { chargeAround $data @($y,$x)}
        }
    }
    #$data[$pos[0]][$pos[1]] = 0

    write-host "$($pos[0]) - $($pos[1])" -fo green
}


# $data | ForEach-Object { $_ -join ' ' }
# write-host

# $data | ForEach-Object { $_ -join ' ' }

#get positions which should flash
for ($step = 1; $step -le 2; $step++) {
    #increment
    for ($y = 0; $y -lt $data.Length; $y++) {
        for ($x = 0; $x -lt ($data[0].Length); $x++) {
            [int]$data[$y][$x] += 1
        }
    }

    #get charged
    while ( $data | ForEach-Object { $_ | Where-Object { $_ -gt 9 } }) {
        $charged = for ($y = 0; $y -lt $data.Length; $y++) {
            for ($x = 0; $x -lt $data[0].Length; $x++) {
                if ($data[$y][$x] -gt 9) { , @($y, $x) }
            }
        }
        if ($charged[0] -is [int]) { $charged = ,@($charged[0],$charged[1]) }

        $charged | % {$_ -join '-'}

        $charged | ForEach-Object { chargeAround $data $_ }
    }
}



