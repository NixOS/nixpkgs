{ lib, stdenv, fetchurl,
  openssl,
 } :

stdenv.mkDerivation rec {
  version = "20210328";
  pname = "mbuffer";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-UbW42EiJkaVf4d/OkBMPnke8HOKGugO09ijAS3hP3F0=";
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
    homepage = "https://www.maier-komor.de/mbuffer.html";
    description  = "A tool for buffering data streams with a large set of unique features";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tokudan ];
    platforms = lib.platforms.linux; # Maybe other non-darwin Unix
  };
}
