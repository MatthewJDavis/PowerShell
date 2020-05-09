[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
#Needs New-MDADUser imported from my AD tools module
$UserList = Import-Csv -Path .\users.csv

$UserListSecure = foreach ($user in $UserList) {
    [pscustomobject]@{
        FirstName = $user.firstname
        Surname   = $user.surname
        Password  = ConvertTo-SecureString -String $user.Password -AsPlainText -Force
    }
}

foreach ($user in $UserListSecure) {
    New-MDADUser -FirstName $user.firstname -Surname $user.surname -Password $user.password
}

<#
Example csv

firstname,surname,password
will,smith,
keith,richards,
Erma,Gilbert,
Stewart,Frank,
Abel,Zimmerman,
Della,Jennings,
Ricardo,Nelson,
Vicky,Clayton,
Caroline,Craig,
Norman,Mitchell,
Molly,Houston,
Belinda,Price,
Brendan,Paul,
Lynne,Ballard,
Olga,Drake,
Marlon,Pierce,
June,Alvarado,
Cornelius,Reynolds,
Rosie,Russell,
Kim,Freeman,
Randal,Bradley,
Troy,Hines,
Casey,Schmidt,
Randy,Benson,
Harry,Warren,
Gwendolyn,Hoffman,
Cindy,Holland,
Cedric,Rice,
Elmer,Vaughn,
Byron,Bowman,
Stephen,Dunn,
Gail,Phelps,
Lorena,Anderson,
Colin,Delgado,
Jason,Duncan,
Francis,Francis,
Marie,Williamson,
Geneva,Obrien,
Bonnie,Cain,
Lucia,Ruiz,
Judy,Davis,
Brenda,Richards,
Edgar,Powers,
Emanuel,Guzman,
Bernadette,Lindsey,
Sheri,Tyler,
Jim,Walker,
Raul,Perkins,
Franklin,Lynch,
Sonya,Rivera,
Elbert,Mason,
Darrell,Johnston,
#>
