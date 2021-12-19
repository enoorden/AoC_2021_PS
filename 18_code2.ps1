function add ([string]$x, [string]$y) {
    return

}

function reduce {}

function explode($sfn, $lvl = 0) {
    if ($sfn -is [string]) {
        $sfn = $sfn | ConvertFrom-Json -Depth 100
    }

    foreach ($s in $sfn) {
        if ($s -is [object[]]) { explode $s ($lvl + 1)}
    }

    if ($lvl -ge 4) {
         write-host "BOOM $($sfn[0]) - $($sfn[1])" -fo red
    }
    $sfn | ConvertTo-Json -Compress -Depth 100
}

$n = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
$n = '[[[[[9,8],1],2],3],4]'
explode $n