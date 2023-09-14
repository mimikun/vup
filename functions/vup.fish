function vup --description 'Tool to update various tools'

    function __help_message
        echo "Usage: vup [-h] "
        echo "         -h --help     Print this help"
    end

    function __brew_update_process
        echo "Running brew update..."
        brew update
        echo "Running brew upgrade..."
        brew upgrade
        echo "Running brew cask upgrade..."
        brew upgrade --cask
        echo "Running brew cleanup..."
        brew cleanup
    end

    set -l options 'h/help'
    argparse -n vup $options -- $argv
    or return 1

    if set -lq _flag_help
        __help_message
        return
    end

    sudo uname > /dev/null
    if test $status != 0
        return
    end

    # OS
    function __ubuntu
        echo "Upgrade APT repogitory list..."
        sudo apt update
        echo "Upgrade APT packages..."
        sudo apt upgrade -y
        echo "Cleaning APT caches..."
        sudo apt autoremove -y
        sudo apt-get clean
        which brew > /dev/null
        if test $status == 0
            __brew_update_process
        end
    end

    function __arch
        echo "Upgrade AUR packages..."
        yay
        echo "Cleaning  caches..."
        yes | yay -Sc
    end

    function __mac
        __brew_update_process
    end

    if test (os_info -t) = "OS type: Ubuntu"
        __ubuntu
    else if test (os_info -t) = "OS type: Arch Linux"
        __arch
    else if test (os_info -t) = "OS type: EndeavourOS"
        __arch
    else if test (os_info -t) = "OS type: Mac OS"
        __mac
    else
        echo "This distro NOT support."
    end

    echo "Upgrade Rust toolchains..."
    rustup update
    echo "Update rust tools..."
    cargo install-update -a
    echo "Create cargo_packages.txt..."
    cargo install-update --list | \
        tail -n +4 | \
        sed -e "s/ /\t/g" | \
        cut -f 1 | \
        sed "/^\$/d" > $HOME/cargo_packages.txt
    echo "Upgrade fisher..."
    fisher update
    echo "Upgrade deno..."
    deno upgrade
    echo "Upgrade bun..."
    bun upgrade
    echo "Upgrade asdf..."
    asdf update
    asdf plugin update --all
    echo "Upgrade asdf tools..."
    for i in (asdf plugin list)
        asdf install $i latest
    end
    asdf install nodejs (asdf nodejs resolve lts --latest-available)
    update_asdf_neovim_master
    update_asdf_neovim_stable
    update_asdf_neovim_nightly
    update_asdf_zig_master
    asdf plugin list --urls > ~/asdf_plugin_list.txt
    yes | update_docker_compose
    yes | update_chromedriver
    yes | update_geckodriver
    yes | update_twitch_cli
    echo "Update tldr..."
    tldr --update
    echo "Upgrade GitHub CLI extensions..."
    gh extensions upgrade --all
    echo "Upgrade flyctl..."
    flyctl version upgrade
    echo "Update fish completions..."
    update_completions

    sleep 5

    if test -e /var/run/reboot-required
        if not test -e /proc/sys/fs/binfmt_misc/WSLInterop
            echo "\"/var/run/reboot-required\" exists. Reboot the system?(recommend)"
            re_boot
        end
    end
end
