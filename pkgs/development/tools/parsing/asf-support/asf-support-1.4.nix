{stdenv, fetchurl, aterm, ptsupport, errorsupport}:

stdenv.mkDerivation {
  name = "asf-support-1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/asf-support-1.4.tar.gz;
    md5 = "520ea7d73094346d3010187f22927870";
  };
  inherit stdenv aterm ptsupport errorsupport;
  buildInputs = [stdenv aterm ptsupport errorsupport];
}
