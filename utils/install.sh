#!/bin/bash

before_sudo() {
  if ! test "$(
    sudo uname >>/dev/null
    echo $?
  )" -eq 0; then
    exit 1
  fi
}

run_install() {
  sudo cp ./"$1".sh ~/.local/bin/"$1"
}

before_sudo
run_install vup
run_install vupueue
