{ stdenv, fetchgit, cmake, SDL2, qtbase, qtmultimedia, boost, curl, gtest }:

stdenv.mkDerivation rec { 
  name = "citra-${version}";
  version = "2018-06-09";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "cf9bfe0690f1934847500cc5079b1aaf3299a507";
    sha256 = "1ryc5d3fnhzlrzh1yljbq9x5n79dsb5hgqdba8z4x56iccx0kd0p";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 qtbase qtmultimedia boost curl gtest ];
  cmakeFlags = [ "-DUSE_SYSTEM_CURL=ON" "-DUSE_SYSTEM_GTEST=ON" ];

  preConfigure = ''
    # Trick configure system.
    sed -n 's,^ *path = \(.*\),\1,p' .gitmodules | while read path; do
      mkdir "$path/.git"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://citra-emu.org;
    description = "An open-source emulator for the Nintendo 3DS";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
