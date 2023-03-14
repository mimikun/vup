function Invoke-Vup() {
    # Update chocolatey packages
    gsudo choco upgrade all

    # Update git for windows
    git update-git-for-windows

    # Update cargo packages
    Invoke-UpdateCargoPackage
}
