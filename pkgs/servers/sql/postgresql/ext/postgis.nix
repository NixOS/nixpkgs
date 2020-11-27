{ fetchurl
, stdenv
, perl
, libxml2
, postgresql
, geos
, proj
, gdal
, json_c
, pkgconfig
, file
, protobufc
, libiconv
, nixosTests
}:
stdenv.mkDerivation rec {
  pname = "postgis";
  version = "3.0.3";

  outputs = [ "out" "doc" ];

  src = fetchurl {
    url = "https://download.osgeo.org/postgis/source/postgis-${version}.tar.gz";
    sha256 = "05s8cx1rlysiq7dd44kf7cid0la61a4p895j9g95bvfb8v8dpzh7";
  };

  buildInputs = [ libxml2 postgresql geos proj gdal json_c protobufc ]
                ++ stdenv.lib.optional stdenv.isDarwin libiconv;
  nativeBuildInputs = [ perl pkgconfig ];
  dontDisableStatic = true;

  # postgis config directory assumes /include /lib from the same root for json-c library
  NIX_LDFLAGS = "-L${stdenv.lib.getLib json_c}/lib";

  preConfigure = ''
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
    configureFlags="--datadir=$out/share/postgresql --datarootdir=$out/share/postgresql --bindir=$out/bin --with-gdalconfig=${gdal}/bin/gdal-config --with-jsondir=${json_c.dev}"

    makeFlags="PERL=${perl}/bin/perl datadir=$out/share/postgresql pkglibdir=$out/lib bindir=$out/bin"
  '';
  postConfigure = ''
    sed -i "s|@mkdir -p \$(DESTDIR)\$(PGSQL_BINDIR)||g ;
            s|\$(DESTDIR)\$(PGSQL_BINDIR)|$prefix/bin|g
            " \
        "raster/loader/Makefile";
    sed -i "s|\$(DESTDIR)\$(PGSQL_BINDIR)|$prefix/bin|g
            " \
        "raster/scripts/python/Makefile";
    mkdir -p $out/bin

    # postgis' build system assumes it is being installed to the same place as postgresql, and looks
    # for the postgres binary relative to $PREFIX. We gently support this system using an illusion.
    ln -s ${postgresql}/bin/postgres $out/bin/postgres
  '';

  # create aliases for all commands adding version information
  postInstall = ''
    # Teardown the illusory postgres used for building; see postConfigure.
    rm $out/bin/postgres

    for prog in $out/bin/*; do # */
      ln -s $prog $prog-${version}
    done

    mkdir -p $doc/share/doc/postgis
    mv doc/* $doc/share/doc/postgis/
  '';

  passthru.tests.postgis = nixosTests.postgis;

  meta = with stdenv.lib; {
    description = "Geographic Objects for PostgreSQL";
    homepage = "https://postgis.net/";
    changelog = "https://git.osgeo.org/gitea/postgis/postgis/raw/tag/${version}/NEWS";
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    inherit (postgresql.meta) platforms;
  };
}
