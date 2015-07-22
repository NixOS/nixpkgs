{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-07-21";

  src = fetchFromGitHub {
    owner = "zfsonlinux";
    repo = "spl";
    rev = "9eb361aaa537724c9a90ab6a9f33521bfd80bad9";
    sha256 = "18sv4mw85fbm8i1s8k4y5dc43l6ll2f6hgfrawvzgvwni5i4h7n8";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
