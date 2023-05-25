﻿<#
.SYNOPSIS
	List coffee prices
.DESCRIPTION
	This PowerShell script queries alphavantage.co and lists the global price of coffee (monthly, in cents per points).
.EXAMPLE
	PS> ./list-coffee-prices
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

function WriteBar { param([string]$Text, [float]$Value, [float]$Max)
	Write-Host "$Text " -noNewline
	$Num = ($Value * 100.0) / $Max
	while ($Num -ge 1.0) { Write-Host "█" -noNewline; $Num -= 1.0 }
	if ($Num -ge 0.875) {
		Write-Host -noNewLine "▉"
	} elseif ($Num -ge 0.75) {
		Write-Host -noNewLine "▊"
	} elseif ($Num -ge 0.625) {
		Write-Host -noNewLine "▋"
	} elseif ($Num -ge 0.5) {
		Write-Host -noNewLine "▌"
	} elseif ($Num -ge 0.375) {
		Write-Host -noNewLine "▍"
	} elseif ($Num -ge 0.25) {
		Write-Host -noNewLine "▎"
	} elseif ($Num -ge 0.125) {
		Write-Host -noNewLine "▏"
	}
	Write-Host " $Value"
}

try {
	$prices = (Invoke-WebRequest -URI "https://www.alphavantage.co/query?function=COFFEE&interval=monthly&apikey=demo" -userAgent "curl" -useBasicParsing).Content | ConvertFrom-Json
	""
	"$($prices.name) (by alphavantage.co, in $($prices.unit))"
	"---------------------------------------------------------------"
	foreach($item in $prices.data) {
		if ($Item.value -eq ".") { continue }
		[string]$date = $item.date
		[int]$value = $Item.value
		WriteBar $date $value 300.0
	}
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
