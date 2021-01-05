# Importation du fichier CSV
Clear-Host

$Chemin  = "YourPath"
$classesFolderPath = $Chemin + "Classes"
$ListClasses = "classes.txt"
$LogFilePath = $Chemin + "logs.log"
$classesFile = $Chemin + $ListClasses
$scriptClassesPath = $Chemin + "Creer1Classe.ps1"
$scriptCreateUserPath = $Chemin + "Creer1Utilisateur.ps1"
$tabClasses = @();
$date = Get-Date -Format "yyyy/MM/dd - HH:MM:ss"

#--- Vérifier l'existance du fichier texte des classes
if(![System.IO.File]::Exists($classesFile))  
{
    Write-Host "Erreur : le fichier de donnees des classes n'existe pas : ", $classesFile
    Write-Host "Sortie du script..."
    exit
}
else
{ 
    Write-Host "Le fichier de donnees des classes existe : ", $classesFile
    New-Item -ItemType "directory" -Path $classesFolderPath | Out-Null
    Write-Host -ForegroundColor Blue "Creation du repertoire Classes"
}

foreach($classe in Get-Content $classesFile) {
    $DirectoryToCreate = $Chemin + "Classes\" + $classe
    $tabClasses += $classe

    Write-Host -ForegroundColor DarkYellow "Traitement pour la classe" $classe " en cours..."
    & $scriptClassesPath $DirectoryToCreate # & sert ici a faire appel au script passé en variable, on parle de projection
    # Equivalent = D:\Cours\Powershell\tpClasses\Creer1Classe.ps1 $DirectoryToCreate
}

Write-Host -ForegroundColor Blue "Liste des classes" 
$tabClasses -join " - " # affichage du tableau contenant les noms des classes

$FilePathEleves = $Chemin + "eleves.csv"
$listCSV = Import-Csv -path $FilePathEleves -delimiter ";"

# Scan de la liste élément par élément
Foreach($ligne IN $listCSV)
{
    if ($tabClasses -contains $ligne.classe)
    {
        Write-Host -ForegroundColor DarkYellow "Traitement pour l'utilisateur" $ligne.nom.ToUpper() $ligne.prenom $ligne.classe.ToUpper() "..."
        & $scriptCreateUserPath $ligne # & sert ici a faire appel au script passé en variable, on parle de projection
    }
    else
    {
        Write-Host -ForegroundColor Red "La classe de l'utilisateur" $ligne.nom "n'existe pas, veuillez verifier cette derniere"
        $date + " [ERROR]: La classe de l'utilisateur " + $ligne.nom.ToUpper() + " " + $ligne.prenom + " n'existe pas, veuillez verifier cette derniere" | Out-File -FilePath $LogFilePath -Append
    }
}
Write-Host -ForegroundColor Blue "Fin du script." 