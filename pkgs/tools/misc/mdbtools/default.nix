{ stdenv, fetchFromGitHub, glib, readline
, bison, flex, pkgconfig, autoreconfHook
, txt2man, which }:

let version = "0.7.1";
in stdenv.mkDerivation {
  name = "mdbtools-${version}";

  src = fetchFromGitHub {
    owner = "brianb";
    repo = "mdbtools";
    rev = version;
    sha256 = "0gwcpp9y09xhs21g7my2fs8ncb8i6ahlyixcx8jd3q97jbzj441l";
  };

  nativeBuildInputs = [ pkgconfig bison flex autoreconfHook txt2man which ];
  buildInputs = [ glib readline ];

  preConfigure = ''
    sed -e 's@static \(GHashTable [*]mdb_backends;\)@\1@' -i src/libmdb/backend.c
  '';

  meta = with stdenv.lib; {
    description = ".mdb (MS Access) format tools";
    homepage = http://mdbtools.sourceforge.net;
    platforms = platforms.unix;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
