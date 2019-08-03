{ stdenv, lib, fetchurl, gzip }:

{
  dvp = stdenv.mkDerivation rec {
    name = "dvp-${version}";
    version = "1.2.1";

    src = fetchurl {
      url = "http://kaufmann.no/downloads/linux/dvp-${lib.replaceStrings ["."] ["_"] version}.map.gz";
      sha256 = "0e859211cfe16a18a3b9cbf2ca3e280a23a79b4e40b60d8d01d0fde7336b6d50";
    };

    nativeBuildInputs = [ gzip ];

    buildCommand = ''
      mkdir -p $out/share/keymaps/i386/dvorak
      gzip -c -d $src > $out/share/keymaps/i386/dvorak/dvp.map
    '';
  };

  neo = stdenv.mkDerivation rec {
    name = "neo-${version}";
    version = "2476";

    src = fetchurl {
      name = "neo.map";
      url = "https://raw.githubusercontent.com/neo-layout/neo-layout/"
          + "a0dee06fed824abfad658b7f10e6d907b270be0a/linux/console/neo.map";
      sha256 = "19mfrd31vzpsjiwc7pshxm0b0sz5dd17xrz6k079cy4im1vf0r4g";
    };

    buildCommand = ''
      install -D $src $out/share/keymaps/i386/neo/neo.map
    '';
  };
}
