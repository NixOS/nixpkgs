{stdenv, fetchurl, aterm, toolbuslib, ptsupport, errorsupport}:

stdenv.mkDerivation {
  name = "sglr-3.11";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/sglr-3.11.tar.gz;
    md5 = "c60536c7e967e93d1ec2cd9c8ae0a4ae";
  };
  inherit stdenv aterm ptsupport toolbuslib errorsupport;
  buildInputs = [stdenv aterm ptsupport toolbuslib errorsupport];
}
