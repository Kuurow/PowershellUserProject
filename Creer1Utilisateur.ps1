Param($user)

function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}

if (!$user.nom -or !$user.prenom -or !$user.classe -or !$user.dateNaissance) 
{
    Write-Host -ForegroundColor Red "Creation impossible de :" $user
    $date + " [ERROR]: Creation impossible de " + $user | Out-File -FilePath $LogFilePath -Append
    break;
}

$nom = Remove-StringLatinCharacters($user.nom).ToUpper() # On retire les caractères spéciaux et on met en majuscules
$prenom = Remove-StringLatinCharacters($user.prenom) # On retire les caractères spéciaux
$userFolderPath = $Chemin + "Classes\" + $user.classe.ToUpper() + "\" + $nom.ToUpper() # Chemin du dossier de l'utilisateur
$id = $nom.Substring(0,4) + $prenom.Substring(0,3).ToUpper() # Création de l'id
$splitedDateNaissance = $user.dateNaissance.Split("/") # Tableau contenenant jour, mois, année de la date de naissance
$mdp = $splitedDateNaissance[0] + "" + $splitedDateNaissance[1] + "" +  $splitedDateNaissance[2].Substring(2,2) # Création du mdp
$userIDFilePath = $userFolderPath + "\id.txt" # Chemin du fichier id.txt de l'utilisateur

if (-not (Test-Path -LiteralPath $userFolderPath)) # Si le repertoire de l'utilisateur n'existe pas
{
    New-Item -ItemType "directory" -Path $userFolderPath | Out-Null
    $date + " [INFO]: Le repertoire de '" + $nom + " " + $prenom + "' en '" + $user.classe.ToUpper() + "' a ete cree !" | Out-File -FilePath $LogFilePath -Append 

    if ($splitedDateNaissance.Length -ne 3) # Si le format ou le contenu de la date n'est pas bon
    {
        $date + " [ERROR]: La date de naissance de '" + $nom + " " + $prenom + "' en '" + $user.classe.ToUpper() + "' n'est pas correcte !" | Out-File -FilePath $LogFilePath -Append 
    }
    else 
    {
        "Id : " + $id + "  MDP : " + $mdp | Out-File -FilePath $userIDFilePath -Append
        $date + " [INFO]: Creation du fichier ID de '" + $nom + " " + $prenom + "' en '" + $user.classe.ToUpper() + "' terminee !" | Out-File -FilePath $LogFilePath -Append
    }
}
else  # S'il existe déjà
{
    $date + " [ERROR]: Le repertoire de '" + $nom + " " + $prenom + "' en '" + $user.classe.ToUpper() + "' existe deja !" | Out-File -FilePath $LogFilePath -Append

    if(Test-Path -LiteralPath $userIDFilePath) # On verifie si l'utilisateur à son fichier id.txt
    {
        $date + " [ERROR]: Le fichier ID  de '" + $nom + " " + $prenom + "' en '" + $user.classe.ToUpper() + "' existe deja !" | Out-File -FilePath $LogFilePath -Append
    }
    else 
    {
        "Id : " + $id + "  MDP : " + $mdp | Out-File -FilePath $userIDFilePath -Append
        $date + " [INFO]: Création du fichier ID de '" + $nom + " " + $prenom + "' en '" + $user.classe.ToUpper() + "' terminee !" | Out-File -FilePath $LogFilePath -Append
    }
}
Write-Host -ForegroundColor Green "Traitement de l'utilisateur" $nom $user.prenom "en classe de" $user.classe.ToUpper() "effectue, veuillez consulter les logs."