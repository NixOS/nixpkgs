{ stdenv, fetchurl, mesa, ioquake3, makeWrapper }:

{ paks, name ? (stdenv.lib.head paks).name, description ? "" }:

stdenv.mkDerivation {
  name = "${name}-${ioquake3.name}";

  builder = ./builder.sh;

  nativeBuildInputs = [ makeWrapper ];
  
  inherit paks mesa;

  game = ioquake3;

  gcc = stdenv.cc.cc;

  preferLocalBuild = true;
  
  meta = {
    inherit description;
  };
}
