{ lib, stdenv, fetchurl,
  openssl,
 } :

stdenv.mkDerivation rec {
  version = "20210209";
  pname = "mbuffer";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-6B8niOJiHyD4SBge8ssZrG0SMoaRQ38wFXSyU/2Jmgw=";
  };

  buildInputs = [ openssl ];

  # The mbuffer configure scripts fails to recognize the correct
  # objdump binary during cross-building for foreign platforms.
  # The correct objdump is exposed via the environment variable
  # $OBJDUMP, which should be used in such cases.
  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace configure --replace "OBJDUMP=$ac_cv_path_OBJDUMP" 'OBJDUMP=''${OBJDUMP}'
  '';
  doCheck = true;

  meta = {
    homepage = "http://www.maier-komor.de/mbuffer.html";
    description  = "A tool for buffering data streams with a large set of unique features";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tokudan ];
    platforms = lib.platforms.linux; # Maybe other non-darwin Unix
  };
}
