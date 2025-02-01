{
  fetchurl,
  lib,
  stdenv,
  perl,
  libxml2,
  postgresql,
  postgresqlTestHook,
  geos,
  proj,
  gdalMinimal,
  json_c,
  pkg-config,
  file,
  protobufc,
  libiconv,
  libxslt,
  docbook_xml_dtd_45,
  cunit,
  pcre2,
  nixosTests,
  jitSupport,
  llvm,
}:

let
  gdal = gdalMinimal;
in
stdenv.mkDerivation rec {
  pname = "postgis";
  version = "3.4.2";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchurl {
    url = "https://download.osgeo.org/postgis/source/postgis-${version}.tar.gz";
    hash = "sha256-yMh0wAukqYSocDCva/lUSCFQIGCtRz1clvHU0INcWJI=";
  };

  buildInputs = [
    libxml2
    postgresql
    geos
    proj
    gdal
    json_c
    protobufc
    pcre2.dev
  ] ++ lib.optional stdenv.isDarwin libiconv;
  nativeBuildInputs = [
    perl
    pkg-config
  ] ++ lib.optional jitSupport llvm;
  dontDisableStatic = true;

  nativeCheckInputs = [
    postgresqlTestHook
    cunit
    libxslt
  ];

  postgresqlTestUserOptions = "LOGIN SUPERUSER";
  failureHook = "postgresqlStop";

  # postgis config directory assumes /include /lib from the same root for json-c library
  env.NIX_LDFLAGS = "-L${lib.getLib json_c}/lib";

  preConfigure = ''
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
    configureFlags="--datadir=$out/share/postgresql --datarootdir=$out/share/postgresql --bindir=$out/bin --docdir=$doc/share/doc/${pname} --with-gdalconfig=${gdal}/bin/gdal-config --with-jsondir=${json_c.dev} --disable-extension-upgrades-install"

    makeFlags="PERL=${perl}/bin/perl datadir=$out/share/postgresql pkglibdir=$out/lib bindir=$out/bin docdir=$doc/share/doc/${pname}"
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

  doCheck = stdenv.isLinux;

  preCheck = ''
    substituteInPlace regress/run_test.pl --replace-fail "/share/contrib/postgis" "$out/share/postgresql/contrib/postgis"
    substituteInPlace regress/Makefile --replace-fail 's,\$$libdir,$(REGRESS_INSTALLDIR)/lib,g' "s,\\$\$libdir,$PWD/regress/00-regress-install$out/lib,g" \
      --replace-fail '$(REGRESS_INSTALLDIR)/share/contrib/postgis/*.sql' "$PWD/regress/00-regress-install$out/share/postgresql/contrib/postgis/*.sql"
    substituteInPlace doc/postgis-out.xml --replace-fail "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" "${docbook_xml_dtd_45}/xml/dtd/docbook/docbookx.dtd"
    # The test suite hardcodes it to use /tmp.
    export PGIS_REG_TMPDIR="$TMPDIR/pgis_reg"
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
    license = licenses.gpl2Plus;
    maintainers =
      with maintainers;
      teams.geospatial.members
      ++ [
        marcweber
        wolfgangwalther
      ];
    inherit (postgresql.meta) platforms;
  };
}
