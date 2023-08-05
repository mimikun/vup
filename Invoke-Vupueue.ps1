function Invoke-Vupueue() {
    # Update scoop
    scoop update
    scoop update -a

    # Update git for windows
    git update-git-for-windows

    # Update cargo packages
    Invoke-PueueUpdateCargoPackage
}
