{ lib, stdenv, fetchurl, pkg-config, glib, libsigrok, libsigrokdecode }:

stdenv.mkDerivation rec {
  pname = "sigrok-cli";
  version = "0.7.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-cdBEPzaJe/Vlcy3sIGgw2+oPJ4m2YBzxBTayhtEUCrg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libsigrok libsigrokdecode ];

  meta = with lib; {
    description = "Command-line frontend for the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
