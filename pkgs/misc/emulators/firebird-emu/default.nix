{ stdenv, fetchFromGitHub, qmake, qtbase, qtdeclarative }:

stdenv.mkDerivation rec {
  pname = "firebird-emu";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "nspire-emus";
    repo = "firebird";
    rev = "v${version}";
    sha256 = "0pdca6bgnmzfgf5kp83as99y348gn4plzbxnqxjs61vp489baahq";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase qtdeclarative ];

  makeFlags = [ "INSTALL_ROOT=$(out)" ];

  # Attempts to install to /usr/bin and /usr/share/applications, which Nix does
  # not use.
  prePatch = ''
    substituteInPlace firebird.pro \
      --replace '/usr/' '/'
  '';

  meta = {
    homepage = https://github.com/nspire-emus/firebird;
    description = "Third-party multi-platform emulator of the ARM-based TI-Nspire™ calculators";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ pneumaticat ];
    # Only tested on Linux, but likely possible to build on, e.g. macOS
    platforms = stdenv.lib.platforms.linux;
  };
}
