{stdenv, fetchurl, db4, groff}:
 
stdenv.mkDerivation {
  name = "man-2.4.3";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/man-db-2.4.3.tar.gz;
    md5 = "30814a47f209f43b152659ba51fc7937";
  };
  buildInputs = [db4 groff];
  configureFlags = "--disable-setuid";
  patches = [
    # Search in "share/man" relative to each path in $PATH (in addition to "man").
    ./share.patch
  ];
}
