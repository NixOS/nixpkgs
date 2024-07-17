{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  runCommand,
  coreutils,
  gnugrep,
  gnused,
  lm_sensors,
  net-snmp,
  openssh,
  openssl,
  perl,
  dnsutils,
  libdbi,
  libmysqlclient,
  uriparser,
  zlib,
  openldap,
  procps,
  runtimeShell,
  unixtools,
}:

let
  binPath = lib.makeBinPath [
    (placeholder "out")
    "/run/wrappers"
    coreutils
    gnugrep
    gnused
    lm_sensors
    net-snmp
    procps
  ];

  mailq = runCommand "mailq-wrapper" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    ln -s /run/wrappers/bin/sendmail $out/bin/mailq
  '';
in
stdenv.mkDerivation rec {
  pname = "monitoring-plugins";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "monitoring-plugins";
    repo = "monitoring-plugins";
    rev = "v${version}";
    sha256 = "sha256-J9fzlxIpujoG7diSRscFhmEV9HpBOxFTJSmGGFjAzcM=";
  };

  patches = [
    # fix build (makefile cannot produce -lcrypto)
    # remove on next release
    (fetchpatch {
      url = "https://github.com/monitoring-plugins/monitoring-plugins/commit/bad156676894a2755c8b76519a11cdd2037e5cd6.patch";
      hash = "sha256-aI/sX04KXe968SwdS8ZamNtgdNbHtho5cDsDaA+cjZY=";
    })
    # fix check_smtp with --starttls https://github.com/monitoring-plugins/monitoring-plugins/pull/1952
    # remove on next release
    (fetchpatch {
      url = "https://github.com/monitoring-plugins/monitoring-plugins/commit/2eea6bb2a04bbfb169bac5f0f7c319f998e8ab87.patch";
      hash = "sha256-CyVD340+zOxuxRRPmtowD3DFFRB1Q7+AANzul9HqwBI=";
    })
  ];

  # TODO: Awful hack. Grrr...
  # Anyway the check that configure performs to figure out the ping
  # syntax is totally impure, because it runs an actual ping to
  # localhost (which won't work for ping6 if IPv6 support isn't
  # configured on the build machine).
  #
  # --with-ping-command needs to be done here instead of in
  # configureFlags due to the spaces in the argument
  postPatch = ''
    substituteInPlace po/Makefile.in.in \
      --replace /bin/sh ${runtimeShell}

    sed -i configure.ac \
      -e 's|^DEFAULT_PATH=.*|DEFAULT_PATH=\"${binPath}\"|'

    configureFlagsArray+=(
      --with-ping-command='${lib.getBin unixtools.ping}/bin/ping -4 -n -U -w %d -c %d %s'
      --with-ping6-command='${lib.getBin unixtools.ping}/bin/ping -6 -n -U -w %d -c %d %s'
    )
  '';

  configureFlags = [
    "--libexecdir=${placeholder "out"}/bin"
    "--with-mailq-command=${mailq}/bin/mailq"
    "--with-sudo-command=/run/wrappers/bin/sudo"
  ];

  buildInputs = [
    dnsutils
    libdbi
    libmysqlclient
    net-snmp
    openldap
    # TODO: make openssh a runtime dependency only
    openssh
    openssl
    perl
    procps
    uriparser
    zlib
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Official monitoring plugins for Nagios/Icinga/Sensu and others";
    homepage = "https://www.monitoring-plugins.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      thoughtpolice
      relrod
    ];
    platforms = platforms.linux;
  };
}
