function add ([string]$x, [string]$y) {
    return

}

function reduce {}

function explode($sfn, $lvl = 0) {
    if ($sfn -is [string]) {
        $sfn = $sfn | ConvertFrom-Json -Depth 100
    }

    for ($i = 0; $i -lt $sfn.Length; $i++) {
        if ($sfn[$i] -is [object[]] -and $lvl -eq 3) {
            $sfn[$i] = "$($sfn[$i][0])_$($sfn[$i][1])"
            break
        } elseif ($sfn[$i] -is [object[]]) {
            $null = explode $sfn[$i] ($lvl + 1)
        } elseif ($sfn[$i] -gt 9) {
            $sfn[$i] = @([int][math]::Floor($sfn[$i] / 2), [int][math]::Ceiling(($sfn[$i] / 2)))
            continue
        }
    }

    $sfn | ConvertTo-Json -Compress -Depth 100
}

$n = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
$n = '[[[[[9,8],1],2],3],4]'
#$n = '[[[[0,7],4],[15,[0,13]]],[1,1]]'
$n = '[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]'
explode $n