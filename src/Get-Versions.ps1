$mods = @()
$nexusBaseLink = 'https://www.nexusmods.com/stardewvalley/mods/'


foreach ($d in Get-ChildItem -Attributes Directory)
{
    $mods += (Get-Content (Join-Path $d -ChildPath "manifest.json") | Out-String | ConvertFrom-Json)
}

#Get the needed info, pad by 4 to the right to give reading space
$longestName = ($mods.Name | Measure-Object -Property Length -Maximum).Maximum + 4
if ($longestName -lt 7) { $longestName = 7 }
$longestAuthor = ($mods.Author | Measure-Object -Property Length -Maximum).Maximum + 4
if ($longestAuthor -lt 10) { $longestAuthor = 10 }
$longestVersion = ($mods.Version | Measure-Object -Property Length -Maximum).Maximum + 4
if ($longestVersion -lt 11) { $longestVersion = 11 }

$longString = ("Mod".PadRight($longestName) + "Author".PadRight($longestAuthor) + "Version".PadRight($longestVersion) + "Update Link`n" + "".PadRight($longestName - 4, '-') + "`n")

foreach ($mod in $mods)
{
    $longString += ($mod.Name.PadRight($longestName) + $mod.Author.PadRight($longestAuthor) + $mod.Version.PadRight($longestVersion))
    if ($null -ne $mod.UpdateKeys)
    { 
        $longString += "$nexusBaseLink$(($mod.UpdateKeys -split ':')[1])`n"
    }
    else
    {
        $longString += "`n"
    }
}


$longString += "`nAll Mods are assumed to use SMAPI https://smapi.io`nIf an update link is not present, the Mod Manifest did not contain an update key, please check https://mods.smapi.io to find the needed links`n"
Set-Content Version.txt $longString

<# Example output
Mod               Author         Version    Update Link
--------------
Better Junimos    hawkfalcon     1.1.0      https://www.nexusmods.com/stardewvalley/mods/2221
.
.
.

All Mods are assumed to use SMAPI https://smapi.io
If an update link is not present, the Mod Manifest did not contain an update key, please check https://mods.smapi.io to find the needed link(s)

#>
