{ stdenv, fetchurl,
	openssl,
 } :

stdenv.mkDerivation rec {
  version = "20200505";
  pname = "mbuffer";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "02qzy3appah0llg6aa71isl2a5nc93bkzy5r4d682lcy2j1n216c";
  };

  buildInputs = [ openssl ];

  # The mbuffer configure scripts fails to recognize the correct
  # objdump binary during cross-building for foreign platforms.
  # The correct objdump is exposed via the environment variable
  # $OBJDUMP, which should be used in such cases.
  preConfigure = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace configure --replace "OBJDUMP=$ac_cv_path_OBJDUMP" 'OBJDUMP=''${OBJDUMP}'
  '';
  doCheck = true;

  meta = {
    homepage = "http://www.maier-komor.de/mbuffer.html";
    description  = "A tool for buffering data streams with a large set of unique features";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ tokudan ];
    platforms = stdenv.lib.platforms.linux; # Maybe other non-darwin Unix
  };
}
