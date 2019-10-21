{ callPackage, ... }:

callPackage ./generic-2.7.0-latest.nix {
  version = "2.7.0";
  url = "https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu18.04-server/libsgx-enclave-common_2.7.100.4-bionic1_amd64.deb";
  sha256 = "1wjrrl8xv64ic0w2pfk1qwpk0avhzssp0drcanzh89r3pqq4iknz";
}
