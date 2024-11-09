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
  docbook5,
  cunit,
  pcre2,
  nixosTests,
  jitSupport,
  llvm,
  buildPostgresqlExtension,
}:

let
  gdal = gdalMinimal;
in
buildPostgresqlExtension rec {
  pname = "postgis";
  version = "3.5.0";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchurl {
    url = "https://download.osgeo.org/postgis/source/postgis-${version}.tar.gz";
    hash = "sha256-ymmKIswrKzRnrE4GO0OihBPzAE3dUFvczddMVqZH9RA=";
  };

  buildInputs = [
    libxml2
    geos
    proj
    gdal
    json_c
    protobufc
    pcre2.dev
  ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;
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

  setOutputFlags = false;
  preConfigure = ''
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
  '';

  configureFlags = [
    "--with-gdalconfig=${gdal}/bin/gdal-config"
    "--with-jsondir=${json_c.dev}"
    "--disable-extension-upgrades-install"
  ];

  postConfigure = ''
    mkdir -p $out/bin

    # postgis' build system assumes it is being installed to the same place as postgresql, and looks
    # for the postgres binary relative to $PREFIX. We gently support this system using an illusion.
    ln -s ${postgresql}/bin/postgres $out/bin/postgres
  '';

  makeFlags = [
    "PERL=${perl}/bin/perl"
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  preCheck = ''
    substituteInPlace doc/postgis-out.xml --replace-fail "http://docbook.org/xml/5.0/dtd/docbook.dtd" "${docbook5}/xml/dtd/docbook/docbookx.dtd"
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
