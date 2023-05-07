#!/bin/bash

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
  cd ~/pico/pico-examples/build && make -j8 && echo "STEP 15 DONE"
}

function setup_freertos {
  cd ~/pico/ && git clone https://github.com/FreeRTOS/FreeRTOS-Kernel --branch smp --depth 1 && echo "STEP 1 DONE" &&\
  cd ~/pico/pico-examples && export FREERTOS_KERNEL_PATH=~/pico/FreeRTOS-Kernel &&\
  cd ~/pico/pico-examples/build/pico_w &&\
  cmake -DPICO_BOARD=pico_w -DPICO_SDK_PATH=~/pico/pico-sdk -DFREERTOS_KERNEL_PATH=$HOME/pico/FreeRTOS-Kernel -DWIFI_SSID=LEAD -DWIFI_PASSWORD=LEADLEAD .. &&\
  cd ~/pico/pico-examples/build/pico_w/wifi/blink # at this point the .elf2 should be available already ;)
}

function install_opencd {
  # Failed to clone 'src/jtag/drivers/libjaylink' a second time, aborting
    # https://forums.raspberrypi.com/viewtopic.php?t=326692
    # 
  sudo apt install automake autoconf build-essential texinfo libtool libftdi-dev libusb-1.0-0-dev -y && echo "STEP 1 DONE" &&\
  cd ~/pico && git clone https://github.com/raspberrypi/openocd.git --branch rp2040 --recursive --depth=1 && echo "STEP 2 DONE" &&\
  cd ~/pico/openocd && ./bootstrap && ./configure --enable-ftdi --enable-sysfsgpio --enable-bcm2835gpio && make -j4 && sudo make install -y && echo "STEP 3 DONE"
}

function debug_with_swd {
  cd ~/pico/pico-examples && rm -rf build && mkdir build && cd build && export PICO_SDK_PATH=~/pico/pico-sdk && echo "STEP 1 DONE" &&\
  cmake -DCMAKE_BUILD_TYPE=Debug .. && cd hello_world/serial && make -j4 && echo "STEP 2 DONE" &&\
  sudo apt install gdb-multiarch && echo "STEP 3 DONE"
}

function debug_with_vscode {
  sudo apt update && sudo apt install code -y && echo "STEP 1 DONE" &&\
  code --install-extension marus25.cortex-debug && code --install-extension ms-vscode.cmake-tools && code --install-extension ms-vscode.cpptools && echo "STEP 2 DONE" &&\
  code ~/pico/pico-examples/ && echo "STEP 3 DONE" &&\
  export PICO_SDK_PATH=~/pico/pico-sdk && echo "STEP 4 DONE" &&\
  cd ~/pico/pico-examples && mkdir .vscode && cp ide/vscode/launch-raspberrypi-swd.json .vscode/launch.json && cp ide/vscode/settings.json .vscode/settings.json && echo "STEP 5 DONE"
}

function picoprobe_setup {
  # OBS.: INSTALLING GIT-LFS
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && sudo apt-get install git-lfs && git lfs install && echo "STEP 1 DONE" &&\
  install_opencd &&\ && echo "STEP 2 DONE" &&\
  cd ~/pico && git clone https://github.com/raspberrypi/picoprobe.git --depth 1 && cd picoprobe && echo "STEP 3 DONE" &&\
  git submodule update --init && mkdir build && cd build && echo "STEP 4 DONE" &&\
  cd ~/pico/picoprobe/build && export PICO_SDK_PATH=~/pico/pico-sdk && cmake .. && make -j4 && echo "STEP 5 DONE" &&\
  # using Picoprobe with OpenCD
  src/openocd -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2040.cfg -s tcl && target remote localhost:3333 && echo "STEP 6 DONE"
}

while true; do
  
  echo "
  ______  ______  ______  ______  ______  ______  ______  ______  ______  ______  ______ 
 |______||______||______||______||______||______||______||______||______||______||______|
   ____          _        _      _____  _                _____        _                  
  / __ \        (_)      | |    |  __ \(_)              / ____|      | |                 
 | |  | | _   _  _   ___ | | __ | |__) |_   ___  ___   | (___    ___ | |_  _   _  _ __   
 | |  | || | | || | / __|| |/ / |  ___/| | / __|/ _ \   \___ \  / _ \| __|| | | || '_ \  
 | |__| || |_| || || (__ |   <  | |    | || (__| (_) |  ____) ||  __/| |_ | |_| || |_) | 
  \___\_\ \__,_||_| \___||_|\_\ |_|    |_| \___|\___/  |_____/  \___| \__| \__,_|| .__/  
                                                                                 | |     
                                                                                 |_|     
  ______  ______  ______  ______  ______  ______  ______  ______  ______  ______  ______ 
 |______||______||______||______||______||______||______||______||______||______||______|"
  echo "If you are developing for Raspberry Pi Pico, most of the installation steps in the Getting
Started guide can be accomplished by executing this script. For official documentation, please
consult the following: https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf
  
  "
  echo "Please choose an option:"
  echo "0. Exit"
  echo "1. Setup Raspberry Pico in SDK mode"
  echo "2. Setup Raspberry Pico alongside FreeRTOS"
  echo "3. Install OpenCD"
  echo "4. Install requirements to debug with SWD"
  echo "5. Debug with vscode"
  echo "6. Picoprobe Setup"
  read -p "Enter your choice: " choice

  case $choice in
    0) break ;;
    1) setup_pico_sdk; break ;;
    2) setup_freertos; break ;;
    3) install_opencd; break ;;
    4) debug_with_swd; break ;;
    5) debug_with_vscode; break;;
    6) picoprobe_setup; break;;

    *) echo "Invalid choice. Please try again." ;;
  esac
done
