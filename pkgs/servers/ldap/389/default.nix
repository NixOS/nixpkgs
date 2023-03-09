{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, cracklib
, lmdb
, json_c
, linux-pam
, libevent
, libxcrypt
, nspr
, nss
, openldap
, withOpenldap ? true
, db
, withBdb ? true
, cyrus_sasl
, icu
, net-snmp
, withNetSnmp ? true
, krb5
, pcre2
, python3
, rustPlatform
, openssl
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, zlib
, rsync
, withCockpit ? true
, withAsan ? false
}:

stdenv.mkDerivation rec {
  pname = "389-ds-base";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "389ds";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-14zl0zGVb8ykgtjao8QGakFyr+b5Cve0NbiZeZig/Ac=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/src";
    name = "${pname}-${version}";
    hash = "sha256-C7HFv6tTBXoi0a1yEQeGjcKjruvBrm/kiu5zgUUTse0=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    python3
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
  ]
  ++ lib.optional withCockpit rsync;

  buildInputs = [
    cracklib
    lmdb
    json_c
    linux-pam
    libevent
    libxcrypt
    nspr
    nss
    cyrus_sasl
    icu
    krb5
    pcre2
    openssl
    zlib
  ]
  ++ lib.optional withSystemd systemd
  ++ lib.optional withOpenldap openldap
  ++ lib.optional withBdb db
  ++ lib.optional withNetSnmp net-snmp;

  postPatch = ''
    patchShebangs ./buildnum.py ./ldap/servers/slapd/mkDBErrStrs.py
  '';

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';

  preBuild = ''
    mkdir -p ./vendor
    tar -xzf ${cargoDeps} -C ./vendor --strip-components=1
  '';

  configureFlags = [
    "--enable-rust-offline"
    "--enable-autobind"
  ]
  ++ lib.optionals withSystemd [
    "--with-systemd"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ] ++ lib.optionals withOpenldap [
    "--with-openldap"
  ] ++ lib.optionals withBdb [
    "--with-db-inc=${lib.getDev db}/include"
    "--with-db-lib=${lib.getLib db}/lib"
  ] ++ lib.optionals withNetSnmp [
    "--with-netsnmp-inc=${lib.getDev net-snmp}/include"
    "--with-netsnmp-lib=${lib.getLib net-snmp}/lib"
  ] ++ lib.optionals (!withCockpit) [
    "--disable-cockpit"
  ] ++ lib.optionals withAsan [
    "--enable-asan"
    "--enable-debug"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=${placeholder "TMPDIR"}"
  ];

  passthru.version = version;

  meta = with lib; {
    homepage = "https://www.port389.org/";
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ners ];
  };
}
