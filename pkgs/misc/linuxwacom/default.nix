{stdenv, fetchurl, libX11, libXi, udevSupport ? false}:

stdenv.mkDerivation {
  name = "linuxwacom-0.7.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/linuxwacom-0.7.2.tar.bz2;
    md5 = "3f6290101d5712a24097243ca9f092ed";
  };
  buildInputs = [libX11 libXi];
  udevRules = ./10-wacom.rules;
  inherit udevSupport;
}
