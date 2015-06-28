{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.4.1";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "1rlflraj66ag2gcvzsyfl4zwhq4846ifyzdmnnmscwmdf2qxc1l8";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
