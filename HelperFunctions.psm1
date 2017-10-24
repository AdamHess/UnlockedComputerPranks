Function Save-OriginalWallpaper() {
  if (Test-Path -Path  ([Environment]::GetFolderPath("Desktop")+ "\OriginalWallpaper.txt"))
  {
    return;
  }
 #get Wallpaper and write to temp file 
 $originalWallpaper = (Get-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -Name Wallpaper ).Wallpaper;  
 echo $originalWallpaper > OriginalWallpaper.txt; 
 
  #save Config and wallpaper to flashdrive 
 $name =  "_" + $env:USERNAME + "_" + $env:COMPUTERNAME + "_"
 $filepath = ".\Undo\Walpaper$name.txt" 
 Copy-Item OriginalWallpaper.txt "$filepath"  -Force
 $filename = [System.IO.Path]::GetFileNameWithoutExtension($originalWallpaper) + $name + [System.IO.Path]::GetExtension($originalWallpaper);  
 Copy-Item $originalWallpaper ".\Undo\$filename"
 
 #Save wallpaper to user disk move generic file off flash drive
 Move-Item OriginalWallpaper.txt (Get-SaveLocalUserDirectory).ToString();
 Copy-Item $originalWallpaper (Get-SaveLocalUserDirectory).ToString();
}

Function Set-Desktop-WallPaper($Value)
{

 Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $value
 Trigger-WallpaperChange;
}


Function Save-OriginalMouseCursor() {
    if (Test-Path -Path  ([Environment]::GetFolderPath("Desktop") + "\OriginalCursor.txt")) {
        return;
     }
     $originalCursor = (Get-ItemProperty -path 'HKCU:\Control Panel\Cursors' -Name Arrow ).Arrow;
     echo "$originalCursor" > OriginalCursor.txt
     #save Configuration and Cursor to flashdrive 
     $name =  "_" + $env:USERNAME + "_" + $env:COMPUTERNAME + "_"
     $filename = [System.IO.Path]::GetFileNameWithoutExtension($originalCursor) + $name + [System.IO.Path]::GetExtension($originalCursor);     
     Copy-Item OriginalCursor.txt ".\Undo\OriginalCursor$name.txt" -Force
     Copy-Item $originalCursor ".\undo\$filename"
     #move to users disk
     Move-Item OriginalCursor.txt (Get-SaveLocalUserDirectory).ToString()
     Copy-Item $originalCursor (Get-SaveLocalUserDirectory).ToString()

}

Function Set-MouseCursor($Value)
{
 #will only change main arror
 Set-ItemProperty -path 'HKCU:\Control Panel\Cursors' -name Arrow -value $Value
 Trigger-MouseCursorChange;
}

Function Trigger-MouseCursorChange()
{    
    Trigger-RegistryRefresh 0x0057;
}

Function Trigger-WallpaperChange() 
{
   Trigger-RegistryRefresh 0x0014;
}

Function Trigger-RegistryRefresh($refreshParameter) {

try {
    $CSharpSig = @'
    [DllImport("user32.dll", SetLastError = true, EntryPoint = "SystemParametersInfo")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SystemParametersInfo(
                     uint uiAction,
                     uint uiParam,
                     bool pvParam,
                     uint fWinIni);
'@  
 
    $CursorRefresh = Add-Type -MemberDefinition $CSharpSig -Name WinAPICall -Namespace SystemParamInfo –PassThru
    }
    catch { }
    finally {
    $CursorRefresh::SystemParametersInfo($refreshParameter, 0, $null, 0)
    }

}

Function ChangeCursorAndWallpaper() {
    $undoDirectory = (Get-SaveLocalUserDirectory);
    New-Item -ItemType Directory -Path $undoDirectory -Force;
    $randomBackground = Get-Random -InputObject (Get-ChildItem .\NickCage\Background);
    Copy-Item $randomBackground.PSPath $undoDirectory\BackgroundImage.jpg -Force;    
    Save-OriginalWallpaper;     
    Set-Desktop-WallPaper "$undoDirectory\BackgroundImage.jpg";

    $randomCursor = Get-Random -InputObject (Get-ChildItem .\NickCage\MouseIcons);
    Copy-Item $randomCursor.PSPath $undoDirectory\cursor.cur -Force;       
    Save-OriginalMouseCursor;
    Set-MouseCursor "$undoDirectory\cursor.cur";
    Copy-Item HelperFunctions.psm1 $undoDirectory
    Copy-Item UndoPrank.ps1 $undoDirectory
}


Function Reset-CursorAndWallPaperToEmpty() {
    Set-Desktop-WallPaper "";
    Set-MouseCursor "";
}
Function Get-SaveLocalUserDirectory() {
    return [Environment]::GetFolderPath("Desktop") + "\UndowWackyChanges"
}

Function Set-CursorAndWallPaperToOriginalSettings() {
   $directoryPrefix = (Get-SaveLocalUserDirectory);
   Set-Desktop-WallPaper ([IO.File]::ReadAllText("$directoryPrefix\OriginalWallpaper.txt")).Trim();
   Set-MouseCursor ([IO.File]::ReadAllText("$directoryPrefix\OriginalCursor.txt")).Trim();
    
}

Export-ModuleMember -Function Set-CursorAndWallPaperToOriginalSettings, ChangeCursorAndWallpaper, Reset-CursorAndWallPaperToEmpty