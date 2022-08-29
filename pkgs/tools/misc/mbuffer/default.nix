{ lib
, stdenv
, fetchurl
, openssl
, which
}:

stdenv.mkDerivation rec {
  pname = "mbuffer";
  version = "20220418";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-blgB+fX/EURdHQMCi1oDzQivVAhpe3+UxCeDMiijAMc=";
  };

  buildInputs = [
    openssl
    which
  ];

  # The mbuffer configure scripts fails to recognize the correct
  # objdump binary during cross-building for foreign platforms.
  # The correct objdump is exposed via the environment variable
  # $OBJDUMP, which should be used in such cases.
  preConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace configure \
      --replace "OBJDUMP=$ac_cv_path_OBJDUMP" 'OBJDUMP=''${OBJDUMP}'
  '';

  doCheck = true;

  meta = with lib; {
    description  = "A tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tokudan ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
