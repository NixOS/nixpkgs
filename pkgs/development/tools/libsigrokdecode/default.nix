{ stdenv, fetchurl, pkgconfig, glib, python3, libsigrok, check }:

stdenv.mkDerivation rec {
  name = "libsigrokdecode-0.5.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/libsigrokdecode/${name}.tar.gz";
    sha256 = "1w434nl1syjkvwl08lji3r9sr60lbxp1nqys8hqwzv2lgiwrx3g0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib python3 libsigrok check ];

  meta = with stdenv.lib; {
    description = "Protocol decoding library for the sigrok signal analysis software suite";
    homepage = https://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
