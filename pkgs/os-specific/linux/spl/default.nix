{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.3-1.3";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "1d4gdlkhshlyfkswbqx06fhs8m5lxgk3vhds6g7ipd3q93ngrczx";
  };

  patches = [ ./install_prefix.patch ./const.patch ];
})
