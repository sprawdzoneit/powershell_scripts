# Hyper-V virtual machine creation by sprawdzone.it

# import module
Import-Module Hyper-V

# set VM name
$VMname = "win11eng"

# set VM switch
$VMSwitch = "Default Switch"

# set ISO path
$ISO = "C:\data\iso\Win11_23H2_EnglishInternational_x64v2.iso"

# set VM path
$VMPath = "C:\data\vm\$VM"

# set VHDX path
$VHDX = "$VMPath\$VM.vhdx"

# create VM
New-VM -Name $VMname -MemoryStartupBytes 4GB -Path $VMPath -NewVHDPath $VHDX -NewVHDSizeBytes 64GB -Generation 2 -SwitchName $Switch

# add ISO to VM
Add-VMDvdDrive -VMName $VMname -Path $ISO

# change boot order + and enable SecureBoot (for Win11)
Set-VMFirmware -VMName $VMname -BootOrder $(Get-VMDvdDrive -VMName $VMname), $(Get-VMHardDiskDrive -VMName $VMname), $(Get-VMNetworkAdapter -VMName $VMname) -EnableSecureBoot On

# start VM
Start-VM $VMname
