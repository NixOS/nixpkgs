{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.3-1.2";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "0id0m3sfpkz8w7b2pc51px8kvz8xnaf8msps57ddarxidmxvb45g";
  };

  patches = [ ./install_prefix.patch ./const.patch ./time.patch ];
})
