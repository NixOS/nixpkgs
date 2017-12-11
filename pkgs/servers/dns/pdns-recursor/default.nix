{ stdenv, fetchurl, pkgconfig, boost
, openssl, systemd, lua, luajit, protobuf
, enableLua ? false
, enableProtoBuf ? false
}:

assert enableLua      -> lua != null && luajit != null;
assert enableProtoBuf -> protobuf != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pdns-recursor-${version}";
  version = "4.0.7";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-recursor-${version}.tar.bz2";
    sha256 = "1rwl5w960ck4lxrjrrh27ipy6d1sf9dsw0dkr46bswicqda1cvcn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost openssl systemd
  ] ++ optional enableLua [ lua luajit ]
    ++ optional enableProtoBuf protobuf;

  configureFlags = [
    "--enable-reproducible"
    "--with-systemd"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A recursive DNS server";
    homepage = http://www.powerdns.com/;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
