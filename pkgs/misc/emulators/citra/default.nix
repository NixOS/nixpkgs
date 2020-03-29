{ stdenv, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost }:

stdenv.mkDerivation {
  pname = "citra";
  version = "2020-03-28";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "a6ee1bf913abca29b5794adba8108af285d38925";
    sha256 = "1wibb1myj8fzkfbfvmwp1c75j3im32n0zyj2q8dk6j5xwynxiijd";
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
