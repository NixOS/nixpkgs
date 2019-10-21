{ callPackage, ... }:

callPackage ./generic-2.3.1-2.7.0.nix {
  version = "2.4.0";
  url = "https://download.01.org/intel-sgx/linux-2.4/ubuntu18.04-server/libsgx-enclave-common_2.4.100.48163-bionic1_amd64.deb";
  sha256 = "1bl2rw229pndlji336dl9d25wdimhbv1bb53a3rbx4vxr0d1aihf";
}
