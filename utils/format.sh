#!/bin/bash

current_dir=$(pwd)

run_shfmt() {
  shfmt ./"$1" >./fmt-"$1"
  mv ./fmt-"$1" ./"$1"
  chmod +x ./"$1"
}

run_shfmt vup.sh
run_shfmt vupueue.sh

cd utils || exit
run_shfmt format.sh
run_shfmt install.sh
run_shfmt lint.sh
run_shfmt clean.sh
run_shfmt create-patch.sh
cd "$current_dir" || exit
