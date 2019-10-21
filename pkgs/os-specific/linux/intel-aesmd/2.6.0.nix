{ callPackage, ... }:

callPackage ./generic-2.3.1-2.7.0.nix {
  version = "2.6.0";
  url = "https://download.01.org/intel-sgx/linux-2.6/ubuntu18.04-server/libsgx-enclave-common_2.6.100.51363-bionic1_amd64.deb";
  sha256 = "1z3zhjx9xd1ja0160pj93smfjk3m94g7j2rb1rpz9siphp5q09d5";
}
