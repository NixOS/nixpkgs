{ fetchurl, fetchFromGitHub, stdenv, wxGTK30, freeimage, cmake, zziplib, mesa, boost,
  pkgconfig, libuuid, openal, ogre, ois, curl, gtk, pixman, mygui, unzip,
  angelscript, ogrepaged, mysocketw, libxcb
  }:

stdenv.mkDerivation rec {
  version = "git-20160412";
  name = "rigsofrods-${version}";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "rigs-of-rods";
    rev = "1ebd359dbd467b4c3171dd6d054e7d8ec39f78ba";
    sha256 = "0h71nrgq5r5cnh20c7wl8jzyaf50dj1b5jdrwihnklpsfyfvjlw4";
  };

  contentPackSrc = fetchurl {
    url = mirror://sourceforge/rigsofrods/rigsofrods/0.37/content-pack-0.37.zip;
    sha256 = "0prvn8lxqazadad4mv0nilax9i4vqb9s7dp7mqzvqc0ycmcnf4ps";
  };

  enableParallelBuilding = true;

  #cmakeFlags = [
  #  "-DROR_USE_CURL=TRUE"
  #  "-DROR_USE_MYGUI=TRUE"
  #  "-DROR_USE_OPNEAL=TRUE"
  #  "-DROR_USE_CAELUM=TRUE"
  #  "-DROR_USE_PAGED=TRUE"
  #  "-DROR_USE_ANGELSCRIPT=TRUE"
  #  "-DROR_USE_SOCKETW=TRUE"
  #  "-DCMAKE_BUILD_TYPE=Release"
  #];

  installPhase = ''
    sed -e "s@/usr/local/lib/OGRE@${ogre}/lib/OGRE@" -i ../tools/linux/binaries/plugins.cfg
    mkdir -p $out/share/rigsofrods
    cp -r bin/* $out/share/rigsofrods
    cp ../tools/linux/binaries/plugins.cfg $out/share/rigsofrods
    mkdir -p $out/bin
    ln -s $out/share/rigsofrods/{RoR,rorconfig} $out/bin
    cd $out/share/rigsofrods
    mkdir packs
    cd packs
    unzip "${contentPackSrc}"
  '';

  #patches = [ ./paths.patch ];

  buildInputs = [ wxGTK30 freeimage cmake zziplib mesa boost pkgconfig
    libuuid openal ogre ois curl gtk mygui unzip angelscript
    ogrepaged mysocketw libxcb ];

  meta = {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = http://rigsofrods.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
