{ fetchurl, fetchFromGitHub, stdenv, wxGTK30, freeimage, cmake, zziplib, libGLU_combined, boost,
  pkgconfig, libuuid, openal, ogre, ois, curl, gtk2, pixman, mygui, unzip,
  angelscript, ogrepaged, mysocketw, libxcb
  }:

stdenv.mkDerivation rec {
  version = "0.4.7.0";
  name = "rigsofrods-${version}";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "rigs-of-rods";
    rev = version;
    sha256 = "0cb1il7qm45kfhh6h6jwfpxvjlh2dmg8z1yz9kj4d6098myf2lg4";
  };

  enableParallelBuilding = true;

  installPhase = ''
    sed -e "s@/usr/local/lib/OGRE@${ogre}/lib/OGRE@" -i ../tools/linux/binaries/plugins.cfg
    mkdir -p $out/share/rigsofrods
    cp -r bin/* $out/share/rigsofrods
    cp ../tools/linux/binaries/plugins.cfg $out/share/rigsofrods
    mkdir -p $out/bin
    ln -s $out/share/rigsofrods/{RoR,RoRConfig} $out/bin
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ wxGTK30 freeimage cmake zziplib libGLU_combined boost
    libuuid openal ogre ois curl gtk2 mygui unzip angelscript
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
