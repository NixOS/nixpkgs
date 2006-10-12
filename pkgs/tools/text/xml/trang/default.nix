{stdenv, fetchurl, jre, unzip}:

stdenv.mkDerivation {
  name = "trang-20030619";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/trang-20030619.zip;
    md5 = "9611ea59fda0f62fecc4a5017a72984e";
  };

  buildInputs = [unzip];

  inherit jre;
}
