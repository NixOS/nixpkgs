{
  stdenv,
  lib,
  fetchurl,
  gnumake,
  libnetfilter_acct,
  libnetfilter_conntrack,
  libnetfilter_log,
  libmnl,
  libnfnetlink,
  automake,
  autoconf,
  autogen,
  libtool,
  postgresql,
  libmysqlclient,
  sqlite,
  pkg-config,
  libpcap,
  linuxdoc-tools,
  autoreconfHook,
  nixosTests,
}:

stdenv.mkDerivation rec {
  version = "2.0.8";
  pname = "ulogd";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    hash = "sha256-Tq1sOXDD9X+h6J/i18xIO6b+K9GwhwFSHgs6/WZ98pE=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  postPatch = ''
    substituteInPlace ulogd.8 --replace "/usr/share/doc" "$doc/share/doc"
  '';

  postBuild = ''
    pushd doc/
    linuxdoc --backend=txt --filter ulogd.sgml
    linuxdoc --backend=html --split=0 ulogd.sgml
    popd
  '';

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} ulogd.conf doc/ulogd.txt doc/ulogd.html README doc/*table
    install -Dm444 -t $out/share/doc/${pname}-mysql doc/mysql*.sql
    install -Dm444 -t $out/share/doc/${pname}-pgsql doc/pgsql*.sql
  '';

  buildInputs = [
    libnetfilter_acct
    libnetfilter_conntrack
    libnetfilter_log
    libmnl
    libnfnetlink
    libpcap
    postgresql
    libmysqlclient
    sqlite
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    automake
    autoconf
    autogen
    libtool
    linuxdoc-tools
  ];

  passthru.tests = { inherit (nixosTests) ulogd; };

  meta = with lib; {
    description = "Userspace logging daemon for netfilter/iptables";
    mainProgram = "ulogd";

    longDescription = ''
      Logging daemon that reads event messages coming from the Netfilter
      connection tracking, the Netfilter packet logging subsystem and from the
      Netfilter accounting subsystem. You have to enable support for connection
      tracking event delivery; ctnetlink and the NFLOG target in your Linux
      kernel 2.6.x or load their respective modules. The deprecated ULOG target
      (which has been superseded by NFLOG) is also supported.

      The received messages can be logged into files or into a MySQL, SQLite3
      or PostgreSQL database. IPFIX and Graphite output are also supported.
    '';

    homepage = "https://www.netfilter.org/projects/ulogd/index.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ p-h ];
  };
}
