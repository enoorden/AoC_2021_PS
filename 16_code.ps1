$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()
function ConvertTo-Binary ($hexStr) {
    $bin += [char[]]$hexStr | ForEach-Object {
        [convert]::ToString([byte]([convert]::ToInt64($_, 16)), 2).PadLeft(4, '0')
    }
    $bin -join ''
}

function Decode ($pck, $nrPck, $nrRemains) {
    if ($nrPck -and $nrPck -eq $nrRemains) { return }

    $pckInfo = @{ Value = '' }
    $stepper = 0

    $version = $pck.Substring($stepper, 3)
    $pckInfo.Version = [convert]::ToInt64($version, 2)
    $global:ver += $pckInfo.Version
    $stepper += 3

    $typeId = $pck.Substring($stepper, 3)
    $pckInfo.Type = [convert]::ToInt64($typeId, 2)
    $stepper += 3

    if ($pckInfo.Type -eq 4) {
        $litValue = @()
        do {
            $byte = $pck.Substring($stepper, 5)
            $stepper += 5
            $litValue += $byte.substring(1, 4)
        } while ($byte[0] -eq '1')

        $literalValue = [convert]::ToInt64(($litValue -join ''), 2)
        $pckInfo.Value = $literalValue

        $remains = $pck.Substring($stepper, ($pck.Length - $stepper))
        if ($remains -and $remains -notmatch '^0*$') {
            $pckInfo.Remains = $remains
        }
    }

    if ($pckInfo.Type -ne 4) {
        $lengthId = $pck.Substring($stepper, 1)
        $pckInfo.LengthId = $lengthId
        $stepper += 1
        if ($lengthId -eq '0') {
            $length = $pck.Substring($stepper, 15)
            $stepper += 15

            $pckInfo.LengthSubPackage = [convert]::ToInt64(($length -join ''), 2)
            $pckInfo.SubPackageStr = $pck.Substring($stepper, ($pck.Length - $stepper)).SubString(0, $pckInfo.LengthSubPackage)
            $stepper += $pckInfo.LengthSubPackage

            $pckInfo.sub = @()
            $pckInfo.sub += Inspect-Packet $pckInfo.SubPackageStr
        } else {
            $packets = $pck.Substring($stepper, 11)
            $stepper += 11
            $pckInfo.NrSubPackage = [convert]::ToInt64(($packets -join ''), 2)
            $pckInfo.SubPackageStr = $pck.Substring($stepper, ($pck.Length - $stepper))

            $pckInfo.sub = @()
            $pckInfo.sub += Inspect-Packet $pckInfo.SubPackageStr $pckInfo.NrSubPackage 0

            $stepper += $pckInfo.SubPackageStr.Length - $pckInfo.sub[-1].Remains.Length
        }
        $remains = $pck.Substring($stepper, ($pck.Length - $stepper))
        if ($remains -and $remains -notmatch '^0*$') {
            $pckInfo.Remains = $remains
        }
    }

    $pckInfo

    if ($pckInfo.Remains) { Inspect-Packet $pckInfo.Remains $nrPck ($nrRemains + 1) }
}

Write-Host 'Day 16 PS'

$hex = '40541D900AEDC01A88002191FE2F45D1006A2FC2388D278D4653E3910020F2E2F3E24C007ECD7ABA6A200E6E8017F92C934CFA0E5290B569CE0F4BA5180213D963C00DC40010A87905A0900021B0D624C34600906725FFCF597491C6008C01B0004223342488A200F4378C9198401B87311A0C0803E600FC4887F14CC01C8AF16A2010021D1260DC7530042C012957193779F96AD9B36100907A00980021513E3943600043225C1A8EB2C3040043CC3B1802B400D3CA4B8D3292E37C30600B325A541D979606E384B524C06008E802515A638A73A226009CDA5D8026200D473851150401E8BF16E2ACDFB7DCD4F5C02897A5288D299D89CA6AA672AD5118804F592FC5BE8037000042217C64876000874728550D4C0149F29D00524ACCD2566795A0D880432BEAC79995C86483A6F3B9F6833397DEA03E401004F28CD894B9C48A34BC371CF7AA840155E002012E21260923DC4C248035299ECEB0AC4DFC0179B864865CF8802F9A005E264C25372ABAC8DEA706009F005C32B7FCF1BF91CADFF3C6FE4B3FB073005A6F93B633B12E0054A124BEE9C570004B245126F6E11E5C0199BDEDCE589275C10027E97BE7EF330F126DF3817354FFC82671BB5402510C803788DFA009CAFB14ECDFE57D8A766F0001A74F924AC99678864725F253FD134400F9B5D3004A46489A00A4BEAD8F7F1F7497C39A0020F357618C71648032BB004E4BBC4292EF1167274F1AA0078902262B0D4718229C8608A5226528F86008CFA6E802F275E2248C65F3610066274CEA9A86794E58AA5E5BDE73F34945E2008D27D2278EE30C489B3D20336D00C2F002DF480AC820287D8096F700288082C001DE1400C50035005AA2013E5400B10028C009600A74001EF2004F8400C92B172801F0F4C0139B8E19A8017D96A510A7E698800EAC9294A6E985783A400AE4A2945E9170'

$binary = (ConvertTo-Binary $hex)

$global:ver = @()
$packet = Decode $binary

Write-Host 'Part1 :'($global:ver | Measure-Object -Sum).Sum
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"

function Calculate ($p, $lvl, $parent) {
    foreach ($sub in $p.sub) { k $sub ($lvl + 1) $p }
    switch ($p.type) {
        '0' { $p.value = ($p.sub.value | Measure-Object -Sum).Sum }
        '1' {
            $v = 1
            $p.sub.value | ForEach-Object { $v *= $_ }
            $p.value = $v
        }
        '2' { $p.value = ($p.sub.value | Measure-Object -Min).Minimum }
        '3' { $p.value = ($p.sub.value | Measure-Object -Max).Maximum }
        '5' { $p.value = $p.sub[0].value -gt $p.sub[1].value ? 1 : 0 }
        '6' { $p.value = $p.sub[0].value -lt $p.sub[1].value ? 1 : 0 }
        '7' { $p.value = $p.sub[0].value -eq $p.sub[1].value ? 1 : 0 }
    }
}

Calculate $packet

Write-Host 'Part2 :' $packet.value
Write-Host "Time Elapsed: $($Stopwatch.Elapsed.ToString())"