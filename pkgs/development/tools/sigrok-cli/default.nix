{ stdenv, fetchurl, pkgconfig, glib, libsigrok, libsigrokdecode }:

stdenv.mkDerivation rec {
  name = "sigrok-cli-0.7.0";

  src = fetchurl {
    url = "https://sigrok.org/download/source/sigrok-cli/${name}.tar.gz";
    sha256 = "072ylscp0ppgii1k5j07hhv7dfmni4vyhxnsvxmgqgfyq9ldjsan";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libsigrok libsigrokdecode ];

  meta = with stdenv.lib; {
    description = "Command-line frontend for the sigrok signal analysis software suite";
    homepage = https://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
