{ lib, stdenv, fetchurl, pkg-config, glib, libsigrok, libsigrokdecode }:

stdenv.mkDerivation rec {
  pname = "sigrok-cli";
  version = "0.7.1";

  src = fetchurl {
    url = "https://sigrok.org/download/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "15vpn1psriadcbl6v9swwgws7dva85ld03yv6g1mgm27kx11697m";
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
