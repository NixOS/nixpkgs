{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.4.2";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "101c5fzhnz67ix5w33rb2pwazxmyz6rfvyszbwy1kgh6rz75bjr4";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
