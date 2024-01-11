#!/bin/bash

#=======================
# 変数定義
#=======================

readonly PRODUCT_VERSION="1.0.0"
PRODUCT_NAME="$(basename "${0}")"
OS_INFO=$(os_info -t)

readonly UBUNTU_OS="OS type: Ubuntu"
readonly ARCH_OS="OS type: Arch Linux"
readonly MAC_OS="OS type: Mac OS"

#=======================
# 関数定義
#=======================

# 使い方、ヘルプメッセージ
usage() {
  cat <<EOF
$PRODUCT_NAME v$PRODUCT_VERSION
Tools to update various packages and commands. (for mimikun)

Usage:
    $PRODUCT_NAME

Options:
    --no_pueue, -n            Run without pueue
    --version, -v, version    Print $PRODUCT_NAME version
    --help, -h, help          Print this help
EOF
}

# バージョン情報出力
version() {
  echo "$PRODUCT_NAME v$PRODUCT_VERSION"
}

# magic
before_sudo() {
  if ! test "$(
    sudo uname >>/dev/null
    echo $?
  )" -eq 0; then
    exit 1
  fi
}

# Ubuntu
ubuntu() {
  # Upgrade APT repogitory list
  sudo apt update
  # Upgrade APT packages
  sudo apt upgrade -y
  # Cleaning APT caches
  sudo apt autoremove -y
  sudo apt-get clean
}

# Arch Linux
arch() {
  paru -Syu
}

# Mac
mac() {
  brew_update
}

# OSごとで処理を分岐
os_pkg_update() {
  case "$OS_INFO" in
  "$UBUNTU_OS") ubuntu ;;
  "$MAC_OS") mac ;;
  "$ARCH_OS") arch ;;
  *) echo "This distro NOT support." ;;
  esac
}

use_pueue() {
  echo "rustup update"
  pueue add -- "rustup update"

  echo "deno upgrade"
  pueue add -- "deno upgrade"

  echo "bun upgrade"
  pueue add -- "bun upgrade"

  echo "mise upgrade"
  pueue add -- "mise upgrade"

  echo "tldr --update"
  pueue add -- "tldr --update"

  echo "gh extensions upgrade --all"
  pueue add -- "gh extensions upgrade --all"

  echo "flyctl version upgrade"
  pueue add -- "flyctl version upgrade"

  echo "update_pnpm"
  pueue add -- "update_pnpm"

  echo "fisher update"
  fish -c 'fisher update'

  echo "update_cargo_packages"
  pueue_update_cargo_packages

  echo "generate_cargo_package_list"
  generate_cargo_package_list

  echo "update_fish_completions"
  update_fish_completions

  echo "gup update"
  pueue add -- "gup update"

  echo "gup export"
  pueue add -- "gup export"

  echo "aqua i -a"
  pueue add -- "aqua i -a"

  echo "aqua up"
  pueue add -- "aqua up"
}

no_pueue() {
  echo "rustup update"
  rustup update

  echo "deno upgrade"
  deno upgrade

  echo "bun upgrade"
  bun upgrade

  echo "mise upgrade"
  mise upgrade

  echo "tldr --update"
  tldr --update

  echo "gh extensions upgrade --all"
  gh extensions upgrade --all

  echo "flyctl version upgrade"
  flyctl version upgrade

  echo "fisher update"
  fish -c 'fisher update'

  echo "update_cargo_packages"
  update_cargo_packages

  echo "generate_cargo_package_list"
  generate_cargo_package_list

  echo "update_pnpm"
  update_pnpm

  echo "update_fish_completions"
  update_fish_completions

  echo "gup update"
  gup update

  echo "gup export"
  gup export

  echo "aqua i -a"
  aqua i -a

  echo "aqua up"
  aqua up
}

other() {
  echo "update_docker_compose"
  update_docker_compose

  echo "update_chromedriver"
  update_chromedriver

  echo "update_geckodriver"
  update_geckodriver

  echo "update_twitch_cli"
  update_twitch_cli

  echo "update_pkgx"
  update_pkgx
}

reboot_check() {
  # ファイルがあれば再起動を促す
  if test -e /var/run/reboot-required; then
    # WSL かチェックする
    if test ! -e /proc/sys/fs/binfmt_misc/WSLInterop; then
      echo "\"/var/run/reboot-required\" exists. Reboot the system?(recommend)"
      re_boot
    fi
  fi
}

#=======================
# メイン処理
#=======================
before_sudo

while (("$#")); do
  case "$1" in
  -h | --help | help)
    usage
    exit 1
    ;;
  -v | --version | version)
    version
    exit 1
    ;;
  -s | -n | --no_pueue | no_pueue)
    os_pkg_update
    no_pueue
    other
    reboot_check
    exit 1
    ;;
  *)
    break
    ;;
  esac
done

os_pkg_update
use_pueue
other
reboot_check
