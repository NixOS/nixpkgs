{ stdenv, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost }:

stdenv.mkDerivation {
  pname = "citra";
  version = "2019-10-05";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "35690e3ac7a340d941d3bf56080cf5aa6187c5c3";
    sha256 = "11a4mdjabn3qrh0nn4pjl5fxs9nhf1k27wd486csfx88q2q9jvq8";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 qtbase qtmultimedia boost ];

  preConfigure = ''
    # Trick configure system.
    sed -n 's,^ *path = \(.*\),\1,p' .gitmodules | while read path; do
      mkdir "$path/.git"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://citra-emu.org";
    description = "An open-source emulator for the Nintendo 3DS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
