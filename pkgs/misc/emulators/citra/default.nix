{ mkDerivation, lib, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost }:

mkDerivation {
  pname = "citra";
  version = "2021-06-22";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "5241032fc58b322e0ede29966dd28490ef0c3cb8";
    sha256 = "0rgwv5cabd6kkfbsak3fwbx7skkg0x31z4qs4c6afd6y4hda1vxv";
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
