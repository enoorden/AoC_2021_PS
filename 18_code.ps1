$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

if ($data) { Remove-Variable data }
$data = (Get-Content .\18_input.txt)



function reduce() {}


$n = '[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]'
function cn($n) {
    $rm = @()

}


function p($str) {
    $stack = [System.Collections.Generic.List[char]]::new()

    foreach ($c in [char[]]$str) {
        if ($c -in $pairs.Values) {
            $stack.Add($c)
        } elseif ($c -in $pairs.Keys) {
            if ($pairs."$c" -eq $stack[-1]) {
                $stack.RemoveAt($stack.count - 1)
            } else {
                if (-not $complete) { return $c }
                else { return }
            }
        }
    }

    if ($stack.Count -eq 0) { return }

    if ($complete) {
        $stack.Reverse()
        return ($stack | ForEach-Object { $pairsClosing."$_" }) -join ''
    }
}