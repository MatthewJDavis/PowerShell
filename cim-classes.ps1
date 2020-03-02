# Useful cim classes
# Search for a class
Get-CimClass -ClassName win32_*disk*

# O/S details
Get-CimInstance -ClassName Win32_OperatingSystem
# Bios details
Get-CimInstance -ClassName Win32_BIOS
# Service details
Get-CimInstance -ClassName Win32_Service

<#
Win32_PhysicalMemory
Win32_ComputerShutdownEvent
Win32_Volume
Win32_LogicalDisk
Win32_NTDomain
Win32_ComputerSystem
Win32_OptionalFeature
#>