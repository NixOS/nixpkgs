{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-09-11";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "f17d005bcc9b7edeb15b10bf947379a504b2d9f7";
    sha256 = "0ryw2vh3px0q38skm53g83p46011ndrdxi3y2kqvd1pjqgfbjdmj";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
