{
  stdenv,
  runCommand,
  lib,
  fetchFromGitHub,
  cmake,
  flex,
  bison,
  systemd,
  boost186,
  libedit,
  openssl,
  patchelf,
  mariadb-connector-c,
  libpq,
  zlib,
  tzdata,
  # Databases
  withMysql ? true,
  withPostgresql ? false,
  # Features
  withChecker ? true,
  withCompat ? false,
  withLivestatus ? false,
  withNotification ? true,
  withPerfdata ? true,
  withIcingadb ? true,
  nameSuffix ? "",
}:

stdenv.mkDerivation rec {
  pname = "icinga2${nameSuffix}";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "icinga";
    repo = "icinga2";
    rev = "v${version}";
    hash = "sha256-w/eD07yzBm3x4G74OuGwkmpBzj63UoklmcKxVi5lx8E=";
  };

  patches = [
    ./etc-icinga2.patch # Makes /etc/icinga2 relative to / instead of the store path
    ./no-systemd-service.patch # Prevent systemd service from being written to /usr
    ./no-var-directories.patch # Prevent /var directories from being created
  ];

  cmakeFlags =
    let
      mkFeatureFlag = label: value: "-DICINGA2_WITH_${label}=${if value then "ON" else "OFF"}";
    in
    [
      # Paths
      "-DCMAKE_INSTALL_SYSCONFDIR=etc"
      "-DCMAKE_INSTALL_LOCALSTATEDIR=/var"
      "-DCMAKE_INSTALL_FULL_SBINDIR=bin"
      "-DICINGA2_RUNDIR=/run"
      "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
      "-DMYSQL_LIB=${mariadb-connector-c.out}/lib/mariadb/libmysqlclient.a"
      "-DICINGA2_PLUGINDIR=bin"
      "-DICINGA2_LTO_BUILD=yes"
      # Features
      (mkFeatureFlag "MYSQL" withMysql)
      (mkFeatureFlag "PGSQL" withPostgresql)
      (mkFeatureFlag "CHECKER" withChecker)
      (mkFeatureFlag "COMPAT" withCompat)
      (mkFeatureFlag "LIVESTATUS" withLivestatus)
      (mkFeatureFlag "NOTIFICATION" withNotification)
      (mkFeatureFlag "PERFDATA" withPerfdata)
      (mkFeatureFlag "ICINGADB" withIcingadb)
      # Misc.
      "-DICINGA2_USER=icinga2"
      "-DICINGA2_GROUP=icinga2"
      "-DICINGA2_GIT_VERSION_INFO=OFF"
      "-DUSE_SYSTEMD=ON"
    ];

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    boost186
    libedit
    openssl
    systemd
  ]
  ++ lib.optional withPostgresql libpq;

  nativeBuildInputs = [
    cmake
    flex
    bison
    patchelf
  ];

  doCheck = true;
  nativeCheckInputs = [ tzdata ]; # legacytimeperiod/dst needs this

  postFixup = ''
    rm -r $out/etc/logrotate.d $out/etc/sysconfig $out/lib/icinga2/prepare-dirs

    # Fix hardcoded paths
    sed -i 's:/usr/bin/::g' $out/etc/icinga2/scripts/*

    # Get rid of sbin
    sed -i 's/sbin/bin/g' $out/lib/icinga2/safe-reload
    rm $out/sbin

    ${lib.optionalString withMysql ''
      # Add dependencies of the MySQL shim to the shared library
      patchelf --add-needed ${zlib.out}/lib/libz.so $(readlink -f $out/lib/icinga2/libmysql_shim.so)

      # Make Icinga find the MySQL shim
      icinga2Bin=$out/lib/icinga2/sbin/icinga2
      patchelf --set-rpath $out/lib/icinga2:$(patchelf --print-rpath $icinga2Bin) $icinga2Bin
    ''}
  '';

  vim = runCommand "vim-icinga2-${version}" { pname = "vim-icinga2"; } ''
    mkdir -p $out/share/vim-plugins
    cp -r "${src}/tools/syntax/vim" $out/share/vim-plugins/icinga2
  '';

  meta = {
    description = "Open source monitoring system";
    homepage = "https://www.icinga.com";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.helsinki-systems ];
  };
}
