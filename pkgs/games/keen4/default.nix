{stdenv, fetchurl, dosbox, unzip}:

stdenv.mkDerivation {
  name = "keen4";
  builder = ./builder.sh;

  dist = fetchurl {
    url = http://nixos.org/tarballs/keen4.zip;
    md5 = "ffcdd9e3bce224d92797166bc3f56f1c";
  };

  buildInputs = [unzip];

  inherit dosbox;

  meta = {
    description = "Commander Keen Episode 4: Secret of the Oracle";
  };
}
