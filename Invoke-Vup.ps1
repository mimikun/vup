function Invoke-Vup() {
    # Update scoop
    scoop update -a

    # Update rustup
    rustup update

    # Update git for windows
    git update-git-for-windows

    # Update cargo packages
    Invoke-UpdateCargoPackage

    # Run Lazy update
    Write-Output "Type ``vim`` and Type ``u``"
}

Set-Alias -Name vup -Value Invoke-Vup
