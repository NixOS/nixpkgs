{stdenv, fetchurl, aterm, toolbuslib, ptsupport}:

stdenv.mkDerivation {
  name = "sglr-3.10.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/sglr-3.10.2.tar.gz;
    md5 = "39aa609be84115d7ddc56a6c74b792b7";
  };
  inherit stdenv aterm ptsupport toolbuslib;
  buildInputs = [stdenv aterm ptsupport toolbuslib];
}
