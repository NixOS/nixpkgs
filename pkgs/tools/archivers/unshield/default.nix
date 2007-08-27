{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "unshield-0.5";
  src = fetchurl {
    url = mirror://sourceforge/synce/unshield-0.5.tar.gz;
    sha256 = "1apdj4qphf6m21lqj9l8sg8rpn85qkp5592w5np9xbhr8776cg3p";
  };
  configureFlags = "--with-zlib=${zlib}";
}
