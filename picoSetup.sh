#!/bin/bash

# for official documentation check the following materiial: https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf 

# function to build the raspberry pico examples with sdk
function setup_pico {
  cd ~/ && mkdir pico && cd pico && echo "STEP 1 DONE" &&\
  git clone https://github.com/raspberrypi/pico-sdk.git --branch master --depth 1 && echo "STEP 2 DONE" &&\
  cd pico-sdk && git submodule update --init && echo "STEP 3 DONE" &&\
  cd ~/pico && echo "STEP 4 DONE" &&\
  git clone https://github.com/raspberrypi/pico-examples.git --branch master --depth 1 && echo "STEP 5 DONE" &&\
  sudo apt update && echo "STEP 6 DONE" &&\
  sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential -y && echo "STEP 7 DONE" &&\
  cd ~/pico/pico-sdk && echo "STEP 8 DONE" &&\
  git pull && echo "STEP 9 DONE" &&\
  git submodule update && echo "STEP 10 DONE" &&\
  cd ~/pico/pico-examples && echo "STEP 11 DONE" &&\
  mkdir build && echo "STEP 12 DONE" &&\
  cd ~/pico/pico-examples/build && echo "STEP 13 DONE" &&\
  export PICO_SDK_PATH=~/pico/pico-sdk && cd ~/pico/pico-examples/build && cmake .. && echo "STEP 14 DONE" &&\
  cd ~/pico/pico-examples/build && make -j8 && echo "STEP 16 DONE"
}

while true; do
  echo "Please choose an option:"
  echo "1. Setup Raspberry Pi Pico development environment"
  echo "2. Do something else"

  read -p "Enter your choice: " choice

  case $choice in
    1) setup_pico; break ;;
    2) echo "Doing something else"; break ;;
    *) echo "Invalid choice. Please try again." ;;
  esac
done
