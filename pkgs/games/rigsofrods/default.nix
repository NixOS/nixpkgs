{ fetchFromGitHub, lib, stdenv, wxGTK30, freeimage, cmake, zziplib, libGLU, libGL, boost,
  pkg-config, libuuid, openal, ogre, ois, curl, gtk3, mygui, unzip,
  angelscript, ogrepaged, mysocketw, libxcb
  }:

stdenv.mkDerivation rec {
  version = "0.4.7.0";
  pname = "rigsofrods";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "rigs-of-rods";
    rev = version;
    sha256 = "0cb1il7qm45kfhh6h6jwfpxvjlh2dmg8z1yz9kj4d6098myf2lg4";
  };

  patches = [
    ./gtk3.patch
  ];

  installPhase = ''
    sed -e "s@/usr/local/lib/OGRE@${ogre}/lib/OGRE@" -i ../tools/linux/binaries/plugins.cfg
    mkdir -p $out/share/rigsofrods
    cp -r bin/* $out/share/rigsofrods
    cp ../tools/linux/binaries/plugins.cfg $out/share/rigsofrods
    mkdir -p $out/bin
    ln -s $out/share/rigsofrods/{RoR,RoRConfig} $out/bin
  '';

  nativeBuildInputs = [ cmake pkg-config unzip ];
  buildInputs = [ wxGTK30 freeimage zziplib libGLU libGL boost
    libuuid openal ogre ois curl gtk3 mygui angelscript
    ogrepaged mysocketw libxcb ];

  meta = with lib; {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = "https://rigsofrods.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
