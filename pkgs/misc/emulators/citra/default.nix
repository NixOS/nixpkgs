{ stdenv, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost }:

stdenv.mkDerivation rec { 
  pname = "citra";
  version = "2019-05-25";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "186ffc235f744dad315a603a98cce4597ef0f65f";
    sha256 = "0w24an80yjmkfcxjzdvsbpahx46bmd90liq5m6qva5pgnpmxx7pn";
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
