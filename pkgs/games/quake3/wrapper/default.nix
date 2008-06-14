{stdenv, fetchurl, game, paks, mesa, name, description, makeWrapper}:

stdenv.mkDerivation {
  builder = ./builder.sh;

  buildInputs = [makeWrapper];
  
  inherit game paks mesa name;

  gcc = stdenv.gcc.gcc;
  
  meta = {
    inherit description;
  };
}
