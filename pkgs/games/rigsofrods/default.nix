{ fetchsvn, stdenv, wxGTK28, freeimage, cmake, zziplib, mesa, boost, pkgconfig,
  libuuid, lua5, openal, ogre, ois, curl, gtk, pixman, mygui }:

stdenv.mkDerivation rec {
  version = "1780";
  name = "rigsofroads-svn-${version}";

  src = fetchsvn {
    url = https://rigsofrods.svn.sourceforge.net/svnroot/rigsofrods/trunk;
    rev = version;
    sha256 = "1i557jc79jpg79kg0gk5a7zsd2m42x89v9q83kzywrzzp1x5imp3";
  };

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DROR_USE_LUA=TRUE" "-DLUA_LIBRARIES=${lua5}/lib/liblua.a"
    "-DROR_USE_CURL=TRUE"
    "-DROR_USE_MYGUI=TRUE"
    # "-DROR_USE_OPNEAL=TRUE"
    # "-DROR_USE_MOFILEREADER=TRUE"
    # "-DROR_USE_CAELUM=TRUE"
    # "-DROR_USE_PAGED=TRUE"
    # "-DROR_USE_ANGELSCRIPT=TRUE"
    # "-DROR_USE_SOCKETW=TRUE"
  ];

  installPhase = ''
    ensureDir $out/bin
    cp ../bin/RoR ../bin/rorconfig $out/bin
  '';

  patches = [ ./wx.patch ];

  buildInputs = [ wxGTK28 freeimage cmake zziplib mesa boost pkgconfig
    libuuid lua5 openal ogre ois curl gtk mygui ];

  meta = {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = http://rigsofrods.sourceforge.net/;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
