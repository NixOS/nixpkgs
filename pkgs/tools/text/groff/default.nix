{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "groff-1.19.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/groff-1.19.2.tar.gz;
    md5 = "f7c9cf2e4b9967d3af167d7c9fadaae4";
  };
}
