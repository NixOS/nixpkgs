{ callPackage, ... }:

callPackage ./generic-2.3.1-2.7.0.nix {
  version = "2.5.0";
  url = "https://download.01.org/intel-sgx/linux-2.5/ubuntu18.04-server/libsgx-enclave-common_2.5.101.50123-bionic1_amd64.deb";
  sha256 = "12pqkzz67xzrdpq31bc6a9kdkkza4s7mx2qadm0dwd6an236l2yh";
}
