{ stdenv, fetchgit, cmake, SDL2, qtbase, boost, curl, gtest }:

stdenv.mkDerivation rec { 
  name = "citra-2018-02-23";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "e51a642a13b9c2eda43d875fe318f627e11d480f";
    sha256 = "0cw9cqbljc87rjyr2alfryp04mxpvd5mdlyrmnp9yis3xr8g9sa1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 qtbase boost curl gtest ];
  cmakeFlags = [ "-DUSE_SYSTEM_CURL=ON" "-DUSE_SYSTEM_GTEST=ON" ];

  preConfigure = ''
    # Trick configure system.
    sed -n 's,^ *path = \(.*\),\1,p' .gitmodules | while read path; do
      mkdir "$path/.git"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://citra-emu.org/;
    description = "An open-source emulator for the Nintendo 3DS capable of playing many of your favorite games.";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
