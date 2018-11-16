{ stdenv, fetchurl, pkgconfig, boost
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:
assert enableProtoBuf -> protobuf != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pdns-recursor-${version}";
  version = "4.1.7";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "0syvxlfxy3h2x1kvqkj7qqk8k85y42qjq30pcqqmy69v3pymq14s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost openssl systemd
    lua luajit
  ] ++ optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--with-systemd"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A recursive DNS server";
    homepage = https://www.powerdns.com/;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
