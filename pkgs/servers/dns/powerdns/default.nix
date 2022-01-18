{ lib, stdenv, fetchurl, fetchpatch, pkg-config, nixosTests
, boost, libyamlcpp, libsodium, sqlite, protobuf, openssl, systemd
, mysql57, postgresql, lua, openldap, geoip, curl, unixODBC
}:

let sha256ByVersion = {
  "4.3.1" = "0if27znz528sir52y9i4gcfhdsym7yxiwjgffy9lpscf1426q56m";
  "4.3.2" = "1ndcpdhc9yg3nb5i26pbd8nkfma8yahnvvicccj7xlinbyvb3znp";
  "4.5.2" = "0h9n0gyfdla9akqx16097zcq4lq981ydlxhfvs6jicxi00jlmnck";
  "4.6.0-rc1" = "0s5csfxhk13r10c3vax28w0ydd9x0f0g4f53pk5y0wkrlg3ipvv9";
};

in stdenv.mkDerivation rec {
  pname = "powerdns";
  version = "4.5.2";
  versionHash = builtins.getAttr version sha256ByVersion;

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = versionHash;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost mysql57.connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl unixODBC openssl systemd
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=bind gmysql geoip godbc gpgsql gsqlite3 ldap lua2 pipe random remote"
      --with-sqlite3
      --with-libcrypto=${openssl.dev}
      --with-libsodium
      --enable-tools
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-reproducible
      --enable-unit-tests
      --enable-systemd
    )
  '';

  enableParallelBuilding = true;
  doCheck = true;

  passthru.tests = {
    nixos = nixosTests.powerdns;
  };

  meta = with lib; {
    description = "Authoritative DNS server";
    homepage = "https://www.powerdns.com";
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 disassembler ];
  };
}
