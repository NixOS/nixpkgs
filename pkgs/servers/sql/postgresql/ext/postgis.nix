{ fetchurl
, lib, stdenv
, perl
, libxml2
, postgresql
, geos
, proj
, gdal
, json_c
, pkg-config
, file
, protobufc
, libiconv
<<<<<<< HEAD
, pcre2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nixosTests
}:
stdenv.mkDerivation rec {
  pname = "postgis";
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "3.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "doc" ];

  src = fetchurl {
    url = "https://download.osgeo.org/postgis/source/postgis-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-rum2CmyITTVBZLMJbEZX8yRFQYZgf4WdHOBdiZeYr50=";
  };

  buildInputs = [ libxml2 postgresql geos proj gdal json_c protobufc pcre2.dev ]
=======
    sha256 = "sha256-miohnaAFoXMKOdGVmhx87GGbHvsAm2W+gP/CW60pkGg=";
  };

  buildInputs = [ libxml2 postgresql geos proj gdal json_c protobufc ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
                ++ lib.optional stdenv.isDarwin libiconv;
  nativeBuildInputs = [ perl pkg-config ] ++ lib.optional postgresql.jitSupport postgresql.llvm;
  dontDisableStatic = true;

  # postgis config directory assumes /include /lib from the same root for json-c library
  NIX_LDFLAGS = "-L${lib.getLib json_c}/lib";

  preConfigure = ''
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
<<<<<<< HEAD
    configureFlags="--datadir=$out/share/postgresql --datarootdir=$out/share/postgresql --bindir=$out/bin --docdir=$doc/share/doc/${pname} --with-gdalconfig=${gdal}/bin/gdal-config --with-jsondir=${json_c.dev} --disable-extension-upgrades-install"

    makeFlags="PERL=${perl}/bin/perl datadir=$out/share/postgresql pkglibdir=$out/lib bindir=$out/bin docdir=$doc/share/doc/${pname}"
=======
    configureFlags="--datadir=$out/share/postgresql --datarootdir=$out/share/postgresql --bindir=$out/bin --with-gdalconfig=${gdal}/bin/gdal-config --with-jsondir=${json_c.dev}"

    makeFlags="PERL=${perl}/bin/perl datadir=$out/share/postgresql pkglibdir=$out/lib bindir=$out/bin"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  meta = with lib; {
    description = "Geographic Objects for PostgreSQL";
    homepage = "https://postgis.net/";
    changelog = "https://git.osgeo.org/gitea/postgis/postgis/raw/tag/${version}/NEWS";
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    inherit (postgresql.meta) platforms;
<<<<<<< HEAD
    broken = versionOlder postgresql.version "12";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
