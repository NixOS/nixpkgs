{stdenv, fetchurl, aterm, toolbuslib, ptsupport, errorsupport}:

stdenv.mkDerivation {
  name = "sdf-support-2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/sdf-support-2.1.tar.gz;
    md5 = "dbb1d3c51a82dadfaaf5319dba5cc9ef";
  };
  inherit stdenv aterm ptsupport toolbuslib errorsupport;
  buildInputs = [stdenv aterm ptsupport toolbuslib errorsupport];
}
