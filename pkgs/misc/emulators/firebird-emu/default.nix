{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase, qtdeclarative }:

mkDerivation rec {
  pname = "firebird-emu";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "nspire-emus";
    repo = "firebird";
    rev = "v${version}";
    sha256 = "sha256-T62WB6msdB6/wIulqd/468JrCEiPGUrvtpjkZyo4wiA=";
    fetchSubmodules = true;
  };

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
    homepage = "https://github.com/nspire-emus/firebird";
    description = "Third-party multi-platform emulator of the ARM-based TI-Nspire™ calculators";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pneumaticat ];
    # Only tested on Linux, but likely possible to build on, e.g. macOS
    platforms = lib.platforms.linux;
  };
}
