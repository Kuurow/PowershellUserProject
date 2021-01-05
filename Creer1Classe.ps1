Param($classe)
$splitedPath = $classe.Split("\")
$nomClasse = $splitedPath[-1]

if ($args -ne $null) {
    Write-Host -ForegroundColor Yellow "Parametres excedentaires : " $args # le tableau des parametres 
}

if (-not (Test-Path -LiteralPath $classe)) {
    New-Item -ItemType "directory" -Path $classe | Out-Null
    $date + " [INFO]: Le repertoire de la classe '" + $nomClasse.ToUpper() + "' a ete cree !" | Out-File -FilePath $LogFilePath -Append 
}
else {
    $date + " [ERROR]: Le repertoire de la classe '" + $nomClasse.ToUpper() + "' existe deja !" | Out-File -FilePath $LogFilePath -Append
}

Write-Host -ForegroundColor Green "Traitement de la classe" $nomClasse.ToUpper() "effectue, veuillez consulter les logs."