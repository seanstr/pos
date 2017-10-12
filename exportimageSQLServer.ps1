$Server = "teswebsql01.tarpon.engy"          
# $Database = "ProjectTracker"        
$Database = "PTDev"        
$Dest = "c:\tmp\tst.png"             
$bufferSize = 8192               
        
$sqlCommand = "SELECT image FROM PTImages WHERE (id = 1)"            
            
# $authentication = "User ID=nbidev;Password=Spring2014!"
$authentication = "Integrated Security=SSPI;"         
$connectionString = "Provider=sqloledb; " +
	                "Data Source=$Server; " +
	                "Initial Catalog=$Database; " +
	                "$authentication; "


$connection = New-Object System.Data.OleDb.OleDbConnection $connectionString
$command = New-Object System.Data.OleDb.OleDbCommand $sqlCommand,$connection
$connection.Open() 
       
$reader = $command.ExecuteReader()            
$out = [array]::CreateInstance('Byte', $bufferSize)            

While ($reader.Read())            
{            
    $fileStream = New-Object System.IO.FileStream $Dest, Create, Write            
    $binaryWriter = New-Object System.IO.BinaryWriter $fileStream            

    $retval = $reader.GetBytes(0, 0, $null, 0, 0)
	$out = [array]::CreateInstance('Byte', $retval)            

	# Read the entire stream into outBytes
	$retval = $reader.GetBytes(0, 0, $out, 0, $retval)
	$binaryWriter.Write($out)            
	$binaryWriter.Flush()                        
    $fileStream.Dispose()      
        
    $binaryWriter.Close()            
    $fileStream.Close()            
}            
            
$fileStream.Dispose()           
$reader.Close()            
$command.Dispose()            
$connection.Close()       

Write-Host "saved to $Dest"