{ lib, stdenv, fetchurl, pkg-config, boost, nixosTests
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:

stdenv.mkDerivation rec {
  pname = "pdns-recursor";
  version = "4.9.5";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    hash = "sha256-HQYr6IxwwnIAghwcYVTuaOTv7Dle/1iO4ec8ToHk9R4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost openssl systemd
    lua luajit
  ] ++ lib.optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
    "sysconfdir=/etc/pdns-recursor"
  ];

  installFlags = [ "sysconfdir=$(out)/etc/pdns-recursor" ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) pdns-recursor ncdns;
  };

  meta = with lib; {
    description = "A recursive DNS server";
    homepage = "https://www.powerdns.com/";
    platforms = platforms.linux;
    badPlatforms = [
      "i686-linux"  # a 64-bit time_t is needed
    ];
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
