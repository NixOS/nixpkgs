{ stdenv, fetchurl, pkgconfig, boost, nixosTests
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:
assert enableProtoBuf -> protobuf != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "pdns-recursor";
  version = "4.4.0";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "12z59xf63iskid08c3y55h238ma2chgvcbks0zprag7i00p97g06";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost openssl systemd
    lua luajit
  ] ++ optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--enable-systemd"
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    nixos = nixosTests.pdns-recursor;
  };

  meta = {
    description = "A recursive DNS server";
    homepage = "https://www.powerdns.com/";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
