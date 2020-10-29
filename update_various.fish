function update_various --description 'Update various things'

  function __help_message
    echo "Usage: update_various [-ah] "

    echo "         -a --all      Update all"
    echo "         -h --help     Print this help"
  end

  set -l options 'a/all' 'h/help'
  argparse -n update_various $options -- $argv
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
    echo "Upgrade snaps..."
    sudo snap refresh
  end

  function __ubuntu_all
    update_docker_compose
    update_geckodriver
    update_peco
    echo "Upgrade rust tools..."
    cargo install exa; sleep 5;
    cargo install bat; sleep 5;
    cargo install du-dust; sleep 5;
    cargo install fd-find; sleep 5;
    cargo install hexyl; sleep 5;
    cargo install procs; sleep 5;
    cargo install tokei; sleep 5;
    cargo install ripgrep; sleep 5;
    cargo install tealdeer; sleep 5;
  end

  function __arch
    echo "Upgrade AUR packages..."
    yay
    echo "Cleaning  caches..."
    yes | yay -Sc
  end

  function __arch_all
    echo "Upgrade rust tools..."
    cargo install du-dust; sleep 5;
    cargo install procs; sleep 5;
  end

  function __mac
    echo "Running brew update..."
    brew update
    echo "Running brew upgrade..."
    brew upgrade
    echo "Running brew cask upgrade..."
    brew cask upgrade
    echo "Running brew cleanup..."
    brew cleanup
  end

  function __mac_all
    echo "Running anyenv update..."
    anyenv update
  end

  if test (get_os_info) = "ubuntu"
    __ubuntu
  else if test (get_os_info) = "arch"
    __arch
  else
    __mac
  end

  if set -lq _flag_all
    echo "Upgrade Rust toolchains..."
    rustup update
    echo "Upgrade fisher..."
    fisher self-update
    echo "Upgrade deno..."
    deno upgrade

    if test (get_os_info) = "ubuntu"
      __ubuntu_all
    else if test (get_os_info) = "arch"
      __arch_all
    else
      __mac_all
    end
  end

  sleep 5

  if test -e /var/run/reboot-required
    echo "\"/var/run/reboot-required\" exists. Reboot the system?(recommend)"
    re_boot
  end
end
