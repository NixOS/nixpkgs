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
}:
stdenv.mkDerivation rec {
  name = "postgis-${version}";
  version = "2.5.1";

  outputs = [ "out" "doc" ];

  src = fetchurl {
    url = "https://download.osgeo.org/postgis/source/postgis-${version}.tar.gz";
    sha256 = "14bsh4kflp4bxilypkpmhrpldknc9s9vgiax8yfhxbisyib704zv";
  };

  buildInputs = [ libxml2 postgresql geos proj perl gdal json_c pkgconfig ];
  dontDisableStatic = true;

  # postgis config directory assumes /include /lib from the same root for json-c library
  NIX_LDFLAGS = "-L${stdenv.lib.getLib json_c}/lib";

  preConfigure = ''
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
    configureFlags="--datadir=$out/share --datarootdir=$out/share --bindir=$out/bin --with-gdalconfig=${gdal}/bin/gdal-config --with-jsondir=${json_c.dev}"

    makeFlags="PERL=${perl}/bin/perl datadir=$out/share pkglibdir=$out/lib bindir=$out/bin"
  '';
  postConfigure = ''
    sed -i "s|@mkdir -p \$(DESTDIR)\$(PGSQL_BINDIR)||g ;
            s|\$(DESTDIR)\$(PGSQL_BINDIR)|$prefix/bin|g
            " \
        "raster/loader/Makefile";
    sed -i "s|\$(DESTDIR)\$(PGSQL_BINDIR)|$prefix/bin|g
            " \
        "raster/scripts/python/Makefile";
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  # create aliases for all commands adding version information
  postInstall = ''
    for prog in $out/bin/*; do # */
      ln -s $prog $prog-${version}
    done

    mkdir -p $doc/share/doc/postgis
    mv doc/* $doc/share/doc/postgis/
  '';

  meta = with stdenv.lib; {
    description = "Geographic Objects for PostgreSQL";
    homepage = http://postgis.refractions.net;
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
