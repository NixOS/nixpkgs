{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-06-10";

  src = fetchgit {
    url = git://github.com/zfsonlinux/spl.git;
    rev = "2345368646151718fa59986d9e2d9d38bcdecb2c";
    sha256 = "08k7ahqgqrf9i118mkfxm01h8s607zp8lyvbvm1crii50dwlvl3g";
  };

  patches = [ ./const.patch ./install_prefix.patch ];
})
