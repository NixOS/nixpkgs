#! /bin/sh -e

insmod $(nix-showOutPath.sh nvidiaDrivers)/src/nv/nvidia.ko

#initctl start xserver
