{ mkDerivation, lib, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost, fetchFromGitHub  }:

mkDerivation {
  pname = "citra";
  version = "2021-07-01";

  # Submodules
  src = fetchFromGitHub {
    owner = "citra-emu";
    repo = "citra";
    rev = "afed4953bccfb9b39558cf196492c2558ca1f109";
    sha256 = "11sicbgxa54wwj3jrklprqiznpxjqmxrymz23lvccyybq3pnmfqj";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 qtbase qtmultimedia boost ];

  dontWrapQtApps = true;

  preConfigure = ''
    # Trick configure system.
    sed -n 's,^ *path = \(.*\),\1,p' .gitmodules | while read path; do
      mkdir "$path/.git"
    done
  '';

  meta = with lib; {
    homepage = "https://citra-emu.org";
    description = "An open-source emulator for the Nintendo 3DS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
