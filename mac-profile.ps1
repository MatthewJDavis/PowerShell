function prompt
{
   "PS" + " " + (Get-Date -format t) + "> "
     $Host.UI.RawUI.WindowTitle = Get-Location
}
