{stdenv, fetchurl, dosbox, unzip}:

stdenv.mkDerivation {
  name = "keen4";
  builder = ./builder.sh;

  dist = /home/eelco/keen4.zip;

  buildInputs = [unzip];

  inherit dosbox;

  meta = {
    description = "Commander Keen Episode 4: Secret of the Oracle";
  };
}
