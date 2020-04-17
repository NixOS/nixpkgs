{ stdenv, mkDerivation, lib, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost }:

mkDerivation {
  pname = "citra";
  version = "2020-03-21";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "8722b970c52f2c0d8e82561477edb62a53ae9dbb";
    sha256 = "0c1zn1f84h4f6n6p0aqz905yvv5qpdmkj2z58yla6bfgbzabfyrj";
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
