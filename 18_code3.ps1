function add ([string]$x, [string]$y) {
    return "[$x,$y]"
}

function procExplosion ($str, [int]$left, [int]$right) {
    $rLeft = [Regex]::new('^.+?(\d{1,10})[\[\]\,\"]+?(?=\"\d{1,10}_)')
    $rRight = [Regex]::new('_\d{1,10}[\[\]\,\"]*(\d{1,10}).*')

    #write-host $str -fo green
    ($rRight.Matches($str).Groups | Where-Object { $_.Length -le 2 }) | Where-Object { $_ } | ForEach-Object {
        $org = [int]$str.Substring($_.index, $_.length)
        $str = $str.Remove($_.index, $_.length).Insert($_.index, $right + $org)
    }

    ($rLeft.Matches($str).Groups | Where-Object { $_.Length -le 2 }) | Where-Object { $_ } | ForEach-Object {
        $org = [int]$str.Substring($_.index, $_.length)

        $str = $str.Remove($_.index, $_.length).Insert($_.index, $left + $org)
    }

    $str = $str -replace '\"\d{1,5}_\d{1,5}\"', '0'

    return $str
}

function explode($nr, $lvl = 0, $global:explosion = $false) {
    if ($nr -is [string]) { $nr = $nr | ConvertFrom-Json -Depth 100 }

    for ($i = 0; $i -lt $nr.Length; $i++) {
        if ($nr[$i] -is [object[]] -and $lvl -ge 3 -and $nr[$i][0] -isnot [object[]] -and $nr[$i][1] -isnot [object[]]) {
            $global:left = $nr[$i][0]
            $global:right = $nr[$i][1]
            $nr[$i] = "$($nr[$i][0])_$($nr[$i][1])"
            $global:explosion = $true
            break
        }
        if ($nr[$i] -is [object[]] -and $global:explosion -eq $false) {
            explode $nr[$i] ($lvl + 1)
        }
    }
    if ($lvl -eq 0) {
        $nr = $nr | ConvertTo-Json -Compress -Depth 100
        if ($global:explosion) {
            $nr = procExplosion $nr $global:left $global:right
        }
        return $nr
    }
}

function split($nr, $lvl = 0, $global:split = $false) {
    if ($nr -is [string]) { $nr = $nr | ConvertFrom-Json -Depth 100 }

    for ($i = 0; $i -lt $nr.Length; $i++) {
        if ($nr[$i] -isnot [object[]] -and $nr[$i] -gt 9 -and $global:split -eq $false) {
            $nr[$i] = @([int][math]::Floor($nr[$i] / 2), [int][math]::Ceiling(($nr[$i] / 2)))
            $global:split = $true
            break
        }
        if ($nr[$i] -is [object[]] -and $global:split -eq $false) {
            split $nr[$i] ($lvl + 1)
        }
    }
    if ($lvl -eq 0) {
        $nr = $nr | ConvertTo-Json -Compress -Depth 100
        return $nr
    }
}

function reduce($nr) {
    do {
        $global:explosion = $false
        $global:split = $false
        $nr = explode $nr
        if ($global:explosion -eq $false) { $nr = split $nr }
    } while ($global:explosion -eq $true -or $global:split -eq $true)
    $nr
}

function magnitude($str, $lvl = 0) {
    if ($str -is [string]) { $str = $str | ConvertFrom-Json -Depth 100 }

    if ($str.count -eq 2 -and $str[0] -is [int64] -and $str[1] -is [int64]) {
        return $str[0] * 3 + $str[1] * 2
    }

    for ($i = 0; $i -lt $str.Length; $i++) {
        if ($str[$i] -is [object[]] -and $str[$i][0] -isnot [object[]] -and $str[$i][0] -isnot [object[]]) {
            $str[$i] = 3 * $str[$i][0] + 2 * $str[$i][1]

        }
        if ($str[$i] -is [object[]]) {
            magnitude $str[$i] ($lvl + 1)
        }
    }

    if ($lvl -eq 0) {
        $str = $str | ConvertTo-Json -Compress -Depth 100
        if ($str -match '^\d.*$') {return $str}
        else {magnitude $str}
    }
}



if ($data) { Remove-Variable data }
$data = (Get-Content .\18_input.txt)

$res = reduce (add (reduce $data[0]) (reduce $data[1]))
for ($i = 2; $i -lt $data.Count; $i++) {
    $res = reduce (add $res (reduce $data[$i]))
    write-host $i -fo green
    $res
}
$res

magnitude $res
