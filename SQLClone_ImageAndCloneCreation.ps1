# Connect to SQL Clone Server
Connect-SqlClone -ServerUrl 'http://redgate-demo:14145/'

# Set variables for Image and Clone Location
$SqlServerInstance = Get-SqlCloneSqlServerInstance -MachineName redgate-demo -InstanceName 'SQLExpress'
$ImageLocation = Get-SqlCloneImageLocation -Path 'C:\Fileshare'
$MaskingScript = New-SqlCloneMask -Path 'C:\Git\Eastwind.DMSMaskSet'
$ImageName = 'Eastwind_MaskedImage_Prod'
$BKP_Location = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\Eastwind.bkp'


# Create New Masked Image from BKP file
# New-SqlCloneImage -Name $ImageName -SqlServerInstance $SqlServerInstance -BackupFileName @($BKP_Location) `
# -Modifications @($MaskingScript) `
# -Destination $ImageLocation | Wait-SqlCloneOperation


# Create New Masked Image from BKP file
New-SqlCloneImage -Name $ImageName -SqlServerInstance $SqlServerInstance  -DatabaseName 'Eastwind' `
-Modifications @($MaskingScript) `
-Destination $ImageLocation | Wait-SqlCloneOperation


# Set Clone names
$Devs = @("Dev_AndersonRangel", "Dev_KendraLittle", "Dev_SteveJones", "FeatureA",  "V1.9", "UAT")

# Create New Clones
$DevImage = Get-SqlCloneImage -Name $ImageName 
$Devs| ForEach-Object { # note - '{' needs to be on same line as 'foreach' !
   $DevImage | New-SqlClone -Name "Eastwind_$_" -Location $SqlServerInstance | Wait-SqlCloneOperation
};