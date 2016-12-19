{ stdenv, fetchurl, pkgconfig, glib, libsigrok, libsigrokdecode }:

stdenv.mkDerivation rec {
  name = "sigrok-cli-0.6.0";

  src = fetchurl {
    url = "http://sigrok.org/download/source/sigrok-cli/${name}.tar.gz";
    sha256 = "0g3jhi7azm256gnryka70wn7j3af42yk19c9kbhqffaz4i7dwbmb";
  };

  buildInputs = [ pkgconfig glib libsigrok libsigrokdecode ];

  meta = with stdenv.lib; {
    description = "Command-line frontend for the sigrok signal analysis software suite";
    homepage = http://sigrok.org/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
