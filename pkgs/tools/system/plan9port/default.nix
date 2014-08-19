{stdenv, fetchurl, libX11, libXt
, xproto ? null
, xextproto ? null
, libXext ? null }:

stdenv.mkDerivation rec {
  name = "plan9port-20140306";

  patches = [ ./fontsrv.patch ];

  builder = ./builder.sh;

  src = fetchurl {
    url = "https://plan9port.googlecode.com/files/${name}.tgz";
    # Google code is much faster than swtch
    # url = "http://swtch.com/plan9port/${name}.tgz";
    sha256 = "1sza12j3db7i54r3pzli8wmby6aiyzmyfj8w0nidmawkwv6jdf6b";
  };

  buildInputs = stdenv.lib.optionals (!stdenv.isDarwin) [ libX11 xproto libXt xextproto libXext ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://swtch.com/plan9port/";
    description = "Plan 9 from User Space";
    license = licenses.lpl-102;
    platforms = platforms.unix;
  };

  inherit libXt;
}
