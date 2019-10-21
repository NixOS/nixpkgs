{ callPackage, ... }:

callPackage ./generic-2.3.1-2.7.0.nix {
  version = "2.3.1";
  url = "https://download.01.org/intel-sgx/linux-2.3.1/ubuntu18.04/libsgx-enclave-common_2.3.101.46683-1_amd64.deb";
  sha256 = "027kkpljg1798rksx6262jngy7kzgjxz9swjgm0jwm6jdh0bna9b";
}
