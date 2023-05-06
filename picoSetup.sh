#!/bin/bash

# for official documentation check the following materiial: https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf 

# function to build the raspberry pico examples with sdk
function setup_pico_sdk {
  cd ~/ && mkdir pico && cd pico && echo "STEP 1 DONE" &&\
  cd ~/pico && git clone https://github.com/raspberrypi/pico-sdk.git --branch master --depth 1 && echo "STEP 2 DONE" &&\
  cd ~/pico/pico-sdk && git submodule update --init && echo "STEP 3 DONE" &&\
  cd ~/pico && echo "STEP 4 DONE" && git clone https://github.com/raspberrypi/pico-examples.git --branch master --depth 1 && echo "STEP 5 DONE" &&\
  sudo apt update && echo "STEP 6 DONE" &&\
  sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential -y && echo "STEP 7 DONE" &&\
  cd ~/pico/pico-sdk && echo "STEP 8 DONE" && git pull && echo "STEP 9 DONE" && git submodule update && echo "STEP 10 DONE" &&\
  cd ~/pico/pico-examples && echo "STEP 11 DONE" && mkdir build && echo "STEP 12 DONE" &&\
  cd ~/pico/pico-examples/build && echo "STEP 13 DONE" &&\
  export PICO_SDK_PATH=~/pico/pico-sdk && cd ~/pico/pico-examples/build && cmake .. && echo "STEP 14 DONE" &&\
  cd ~/pico/pico-examples/build && make -j8 && echo "STEP 16 DONE"
}

function setup_pico_sdk {
  cd ~/pico/ && git clone https://github.com/FreeRTOS/FreeRTOS-Kernel --branch smp --depth 1 && echo "STEP 1 DONE" &&\
  cd ~/pico/pico-examples && export FREERTOS_KERNEL_PATH=~/pico/FreeRTOS-Kernel &&\
  cd ~/pico/pico-examples/build/pico-w &&\
  cmake -DPICO_BOARD=pico_w -DPICO_SDK_PATH=~/pico/pico-sdk -DFREERTOS_KERNEL_PATH=$HOME/pico/FreeRTOS-Kernel -DWIFI_SSID=LEAD -DWIFI_PASSWORD=LEADLEAD .. &&\
  cd ~/pico/pico-examples/build/pico_w/wifi/blink # at this point the .elf2 should be available already ;)
}

function install_opencd {
  sudo apt install automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev -y &&\
  cd ~/pico && git clone https://github.com/raspberrypi/openocd.git --branch rp2040 --recursive --depth=1 &&\
  cd ~/pico/openocd && ./bootstrap && ./configure --enable-ftdi --enable-sysfsgpio --enable-bcm2835gpio && make -j4 && sudo make install
}

function debug_with_swd {
  cd ~/pico/pico-examples && rm -rf build && mkdir build && cd build && export PICO_SDK_PATH=~/pico/pico-sdk &&\
  cmake -DCMAKE_BUILD_TYPE=Debug .. && cd hello_world/serial && make -j4 &&\
  sudo apt install gdb-multiarch
}

function debug_with_vscode {
  sudo apt update && sudo apt install code -y &&\
  code --install-extension marus25.cortex-debug && code --install-extension ms-vscode.cmake-tools && code --install-extension ms-vscode.cpptools &&\
  code ~/pico/pico-examples/ &&\
  export PICO_SDK_PATH=~/pico/pico-sdk &&\
  cd ~/pico/pico-examples && mkdir .vscode && cp ide/vscode/launch-raspberrypi-swd.json .vscode/launch.json && cp ide/vscode/settings.json .vscode/settings.json 
}

function picoprobe_setup {
  # OBS.: INSTALLING GIT-LFS
  #curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && sudo apt-get install git-lfs && git lfs install && echo "STEP 1 DONE" &&\
  #install_opencd &&\ && echo "STEP 1 DONE" &&\
  #cd ~/pico && git clone https://github.com/raspberrypi/picoprobe.git --depth 1 && cd picoprobe && echo "STEP 2 DONE" &&\
  #git submodule update --init && mkdir build && cd build && echo "STEP 3 DONE" &&\
  cd ~/pico/picoprobe/build && export PICO_SDK_PATH=~/pico/pico-sdk && cmake .. && make -j4 && echo "STEP 4 DONE" &&\
  # using Picoprobe with OpenCD
  src/openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2040.cfg -s tcl && target remote localhost:3333 && echo "STEP 5 DONE"
}

while true; do
  echo "Please choose an option:"
  echo "1. Setup Raspberry Pico in SDK mode"
  echo "2. Setup Raspberry Pico alongside FreeRTOS"
  echo "3. Install OpenCD"
  echo "4. Install requirements to debug with SWD"
  echo "5. Debug with vscode"
  echo "6. Picoprobe Setup"
  read -p "Enter your choice: " choice

  case $choice in
    1) setup_pico_sdk; break ;;
    2) setup_pico_sdk; break ;;
    3) install_opencd; break ;;
    4) debug_with_swd; break ;;
    5) debug_with_vscode; break;;
    6) picoprobe_setup; break;;

    *) echo "Invalid choice. Please try again." ;;
  esac
done
