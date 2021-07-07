{ mkDerivation, lib, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost, fetchFromGitHub  }:

mkDerivation {
  pname = "citra";
  version = "2021-06-22";

  # Submodules
  src = fetchFromGitHub {
    owner = "citra-emu";
    repo = "citra";
    rev = "afed4953bccfb9b39558cf196492c2558ca1f109";
    sha256 = "0rgwv5cabd6kkfbsak3fwbx7skkg0x31z4qs4c6afd6y4hda1vxv";
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
