{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "unshield-0.6";
  src = fetchurl {
    url = mirror://sourceforge/synce/Unshield/0.6/unshield-0.6.tar.gz;
    sha256 = "07q48zwvjz9f8barql4b894fzz897agscvj13i6gkpy862aya41b";
  };
  configureFlags = "--with-zlib=${zlib}";
}
