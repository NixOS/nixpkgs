{stdenv, fetchurl, db4, groff}:
 
stdenv.mkDerivation {
  name = "man-db-2.5.1";
  
  src = fetchurl {
    url = http://download.savannah.nongnu.org/releases/man-db/man-db-2.5.1.tar.gz;
    sha256 = "178w1fk23ffh8vabj29cn0yyg5ps7bwy1zrrrcsw8aypbh3sfjy3";
  };
  
  buildInputs = [db4 groff];
  
  configureFlags = ''
    --disable-setuid
    --with-nroff=${groff}/bin/nroff
    --with-tbl=${groff}/bin/tbl
    --with-eqn=${groff}/bin/eqn
    --with-neqn=${groff}/bin/neqn
  '';

  troff = "${groff}/bin/troff";
  
  patches = [
    # Search in "share/man" relative to each path in $PATH (in addition to "man").
    ./share.patch
  ];

  meta = {
    homepage = http://www.nongnu.org/man-db/;
    description = "An implementation of the standard Unix documentation system accessed using the man command";
  };
}
