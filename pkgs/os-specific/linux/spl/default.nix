{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "1jja3aqkm2whb4rcw5k5dr9c4gx6hax1w3f82fb9ks2sy731as6r";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
