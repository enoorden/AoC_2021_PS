[System.Int32[]]$data = Get-Content .\01_input.txt

$inc = 0
0..($data.Count - 1) | ForEach-Object {
    if ($data[$_] -gt $data[$_ - 1]) { $inc++ }
}

Write-Host "Part1 : $inc"


$inc = 0
0..($data.Count - 3) | ForEach-Object {
    $next = $data[$_ + 1] + $data[$_ + 2] + $data[$_ + 3]
    $cur = $data[$_ + 0] + $data[$_ + 1] + $data[$_ + 2]
    if ($next -gt $cur) { $inc++ }
}

Write-Host "Part2 : $inc"
