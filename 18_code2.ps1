function add ([string]$x, [string]$y) {
    return "[$x,$y]"
}

$global:change = $false

function procExplosion ($str) {
    $rLeft = [Regex]::new('^.+?(\d{1,2})[\[\]\,\"]+?(?=\"\d{1,2}_)')
    $rRight = [Regex]::new('_\d{1,2}[\[\]\,\"]*(\d).*')

    ($rRight.Matches($str).Groups | Where-Object { $_.Length -le 2 }) | Where-Object { $_ } | ForEach-Object {
        $org = [int]$str.Substring($_.index, $_.length)
        $str = $str.Remove($_.index, $_.length).Insert($_.index, $global:exRight + $org)
    }

    ($rLeft.Matches($str).Groups | Where-Object { $_.Length -le 2 }) | Where-Object { $_ } | ForEach-Object {
        $org = [int]$str.Substring($_.index, $_.length)

        $str = $str.Remove($_.index, $_.length).Insert($_.index, $global:exLeft + $org)
    }

    $str = $str -replace '\"\d{1,2}_\d{1,2}\"', '0'

    return $str
}

function explode($sfn, $cmd = 'explode', $lvl = 0, $global:change = $false) {
    if ($sfn -is [string]) { $sfn = $sfn | ConvertFrom-Json -Depth 100 }

    if ($cmd -eq 'explode') {
        for ($i = 0; $i -lt $sfn.Length; $i++) {
            if ($sfn[$i] -is [object[]] -and $lvl -ge 3 -and $global:change -eq $false -and $sfn[$i][0] -isnot [object[]] -and $sfn[$i][1] -isnot [object[]]) {
                $global:change = $true
                $global:exLeft = $sfn[$i][0]
                $global:exRight = $sfn[$i][1]
                $sfn[$i] = "$($sfn[$i][0])_$($sfn[$i][1])"
                Write-Host 'BOOM' -fo red
                break
            }
            if ($sfn[$i] -is [object[]]) {
                $null = explode $sfn[$i] $cmd ($lvl + 1) $global:change
            }
        }
    }

    if ($cmd -eq 'split') {
        for ($i = 0; $i -lt $sfn.Length; $i++) {

            if ($sfn[$i] -isnot [object[]] -and $sfn[$i] -gt 9 -and $global:change -eq $false) {
                $sfn[$i] = @([int][math]::Floor($sfn[$i] / 2), [int][math]::Ceiling(($sfn[$i] / 2)))
                $global:change = $true
                Write-Host 'SPLIT' -fo red
                break
            }
            if ($sfn[$i] -is [object[]]) {
                $null = explode $sfn[$i] $cmd ($lvl + 1) $global:change

            }
        }
    }

    if ($lvl -eq 0) {

        $sfn = $sfn | ConvertTo-Json -Compress -Depth 100
        Write-Host $sfn -fo cyan

        if ($global:change -eq $true) {
            $sfn = procexplosion $sfn
            explode $sfn 'explode' 0 -explosion $false
            explode $sfn 'split' 0 -explosion $false
        } else {
            Write-Host $sfn -fo green
            $sfn
        }
    }
}

# function preExplode($str) {
#     $explodedStr = explode $str
#     do {
#         $before = $explodedStr
#         $explodedStr = explode $explodedStr
#     } while ($explodedStr -ne $before)
#     $explodedStr
# }


#preexplode '[[[[4,0],[5,4]],[[7,0],[15,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]'
explode '[[[[4,0],[5,4]],[[7,0],[15,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]'
exit





if ($data) { Remove-Variable data }
$data = (Get-Content .\18_input.txt)

$res = preexplode (add (preexplode $data[0]) (preexplode $data[1]))
$res
# $n = '[[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]'
# preExplode $n
exit

# exit
for ($i = 2; $i -lt $data.Count; $i++) {
    $res
    $res = preExplode (add $res (preexplode $data[$i]))
}
$res
exit

$n = '[[[[[1,1],[2,2]],[3,3]],[4,4]],[5,5]]'
preExplode $n


exit

$str = explode $n


procExplosion $str

preexplode '[[[[4,0],[5,4]],[[7,0],[15,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]'