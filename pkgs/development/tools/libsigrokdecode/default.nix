{ lib, stdenv, fetchurl, pkg-config, glib, python3, check }:

stdenv.mkDerivation rec {
  pname = "libsigrokdecode";
  version = "0.5.3";

  src = fetchurl {
    url = "https://sigrok.org/download/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1h1zi1kpsgf6j2z8j8hjpv1q7n49i3fhqjn8i178rka3cym18265";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib python3 ];
  checkInputs = [ check ];
  doCheck = true;

  meta = with lib; {
    description = "Protocol decoding library for the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
