{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "unshield-0.5.1";
  src = fetchurl {
    url = mirror://sourceforge/synce/unshield-0.5.1.tar.gz;
    sha256 = "0zc6kllw54m925zyh33jwjhk9c7rwcrkyydvhdsixr72fdqacjx3";
  };
  configureFlags = "--with-zlib=${zlib}";
}
