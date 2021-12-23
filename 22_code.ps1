$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

Write-Host 'Day22'

if ($data) { Remove-Variable data }
$data = (Get-Content .\22_input.txt)

$r = [Regex]::new('(-?\d*)\.\.(-?\d*)')
filter dubes { [int[]]$r.Matches($_).groups.value[1, 2, 4, 5, 7, 8] }
$cubes = $data | dubes

$cubes.ForEach({$_ -join ','})



exit
foreach ($d in $data) {
    $cmd, $cuboid = $d.split(' ')
    #[int]$x1, [int]$x2, [int]$y1, [int]$y2, [int]$z1, [int]$z2 = $r.Matches($cuboid).groups.value[1, 2, 4, 5, 7, 8]
    $cube = [int[]]$r.Matches($cuboid).groups.value[1, 2, 4, 5, 7, 8]
    #size $cube
    addcube $cmd $cube $cubes

}








exit
#region part1
# $cubes = @{}
# foreach ($d in $data) {
#     $cmd, $cuboid = $d.split(' ')
#     [int]$x1, [int]$x2, [int]$y1, [int]$y2, [int]$z1, [int]$z2 = $r.Matches($cuboid).groups.value[1, 2, 4, 5, 7, 8]

#     # :)
#     if ($x1 -gt 50 -or $x1 -lt -50) {continue}
#     if ($x2 -gt 50 -or $x2 -lt -50) {continue}
#     if ($y1 -gt 50 -or $y1 -lt -50) {continue}
#     if ($y2 -gt 50 -or $y2 -lt -50) {continue}
#     if ($z1 -gt 50 -or $z1 -lt -50) {continue}
#     if ($z2 -gt 50 -or $z2 -lt -50) {continue}

#     for ($x = $x1; $x -le $x2; $x++) {
#         for ($y = $y1; $y -le $y2; $y++) {
#             for ($z = $z1; $z -le $z2; $z++) {
#                 $cubes["$x!$y!$z"] = $cmd
#             }
#         }
#     }
# }
# $cubes.GetEnumerator() | ? {$_.Value -eq 'on'} | Measure-Object
#endregion

$cubes = [System.Collections.Generic.List[int[]]]::new()
$negacubes = [System.Collections.Generic.List[int[]]]::new()

function between([int]$a, [int]$start, [int]$end, $inclusive = $true) {
    $low, $high = $start, $end | Sort-Object
    if ($inclusive) {
        return $a -ge $low -and $a -le $high ? $true : $false
    } else {
        return $a -gt $low -and $a -lt $high ? $true : $false
    }
}
# cube : @(x1,x2,y1,y2,z1,z2)
function checkOverlap($c1, $c2) {
    $overlap = $true
    if ($c1[0] -gt $c2[1]) { $overlap = $false }
    if ($c1[1] -lt $c2[0]) { $overlap = $false }
    if ($c1[2] -gt $c2[3]) { $overlap = $false }
    if ($c1[3] -lt $c2[2]) { $overlap = $false }
    if ($c1[4] -gt $c2[5]) { $overlap = $false }
    if ($c1[5] -lt $c2[4]) { $overlap = $false }

    return $overlap
}

function size($c) {
    ([math]::abs($c[0] - $c[1]) + 1) *
    ([math]::abs($c[2] - $c[3]) + 1) *
    ([math]::abs($c[4] - $c[5]) + 1)
}

function intersection($c1, $c2) {
    $c = @(0, 0, 0, 0, 0, 0)

    $c[0] = $c1[0] -gt $c2[0] ? $c1[0] : $c2[0]
    $c[1] = $c1[1] -lt $c2[1] ? $c1[1] : $c2[1]

    $c[2] = $c1[2] -gt $c2[2] ? $c1[2] : $c2[2]
    $c[3] = $c1[3] -lt $c2[3] ? $c1[3] : $c2[3]

    $c[4] = $c1[4] -gt $c2[4] ? $c1[4] : $c2[4]
    $c[5] = $c1[5] -lt $c2[5] ? $c1[5] : $c2[5]

    $c
}



function addcube($cmd, $nc, $cubes) {
    Write-Host ($nc -join ',') -fo green
    if ($cubes.count -eq 0) { $cubes.Add($nc); return }
    foreach ($c in $cubes) {
        if (checkOverlap $nc $c) { $negacubes.Add((intersection $nc $c)) }
        if ($cmd -eq 'on') { $cubes.Add($nc) }
        return
    }

    #$cubes.Add($nc)


}


foreach ($d in $data) {
    $cmd, $cuboid = $d.split(' ')
    #[int]$x1, [int]$x2, [int]$y1, [int]$y2, [int]$z1, [int]$z2 = $r.Matches($cuboid).groups.value[1, 2, 4, 5, 7, 8]
    $cube = [int[]]$r.Matches($cuboid).groups.value[1, 2, 4, 5, 7, 8]
    #size $cube
    addcube $cmd $cube $cubes

}

$cubes | ForEach-Object { $_ -join ',' }
#$cubes.GetEnumerator() | ? {$_.Value -eq 'on'} | Measure-Object

$on = 0
$cubes | ForEach-Object { $on += size $_ }
$negacubes | ForEach-Object { $on -= size $_ }

$on

$stopwatch.Stop()
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"