{ stdenv, fetchgit, cmake, SDL2, qtbase, boost, curl, gtest }:

stdenv.mkDerivation rec { 
  name = "citra-2017-07-26";

  # Submodules
  src = fetchgit {
    url = "https://github.com/citra-emu/citra";
    rev = "a724fb365787718f9e44adedc14e59d0854905a6";
    sha256 = "0lkrwhxvq85c0smix27xvj8m463bxa67qhy8m8r43g39n0h8d5sf";
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
