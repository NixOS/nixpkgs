{ lib, stdenv, fetchurl, dosbox, unzip }:

stdenv.mkDerivation {
  name = "keen4";
  builder = ./builder.sh;

  dist = fetchurl {
    url = http://tarballs.nixos.org/keen4.zip;
    sha256 = "12rnc9ksl7v6l8wsxvr26ylkafzq80dbsa7yafzw9pqc8pafkhx1";
  };

  buildInputs = [unzip];

  inherit dosbox;

  meta = {
    description = "Commander Keen Episode 4: Secret of the Oracle";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.eelco ];
  };
}
