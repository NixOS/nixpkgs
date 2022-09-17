{ lib, stdenv, fetchurl, pkg-config, boost, nixosTests
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:

stdenv.mkDerivation rec {
  pname = "pdns-recursor";
  version = "4.7.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "sha256-vbQZB5D+dZd41vBRWvu8wKKLPn4bg8Vwyq84QZ1Xgg0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost openssl systemd
    lua luajit
  ] ++ lib.optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
  ];

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
