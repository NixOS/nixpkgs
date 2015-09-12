{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "spl-${version}";
    sha256 = "0ryw2vh3px0q38skm53g83p46011ndrdxi3y2kqvd1pjqgfbjdmj";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
