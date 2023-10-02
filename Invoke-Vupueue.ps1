function Invoke-Vupueue() {
    # Update scoop
    scoop update -a

    # Update git for windows
    git update-git-for-windows

    # Update rustup
    rustup update

    # Update cargo packages
    Invoke-PueueUpdateCargoPackage

    # Run Lazy update
    Write-Output "Type ``vim`` and Type ``u``"
}

Set-Alias -Name vupueue -Value Invoke-Vupueue
