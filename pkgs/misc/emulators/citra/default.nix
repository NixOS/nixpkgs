{ mkDerivation, lib, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost
, wrapQtAppsHook }:

mkDerivation {
  pname = "citra";
  version = "2021-11-01";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "5a7d80172dd115ad9bc6e8e85cee6ed9511c48d0";
    sha256 = "sha256-vy2JMizBsnRK9NBEZ1dxT7fP/HFhOZSsC+5P+Dzi27s=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ SDL2 qtbase qtmultimedia boost ];

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
