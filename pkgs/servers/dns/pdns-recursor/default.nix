{ stdenv, fetchurl, pkgconfig, boost
, openssl, systemd, lua, luajit, protobuf
, enableProtoBuf ? false
}:
assert enableProtoBuf -> protobuf != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "pdns-recursor";
  version = "4.3.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "1qb18mx0ci3gbm4ssdg6sf2zg1p6xqi0v061ffww6ph0snabmbpw";
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
    homepage = "https://www.powerdns.com/";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
