{ fetchsvn, fetchurl, stdenv, wxGTK29, freeimage, cmake, zziplib, mesa, boost, 
  pkgconfig, libuuid, lua5, openal, ogre, ois, curl, gtk, pixman, mygui, unzip,
  angelscript
  }:

stdenv.mkDerivation rec {
  /* version = "1780"; */
  version = "0.37";
  name = "rigsofrods-${version}";

  /* src = fetchsvn {
    url = https://rigsofrods.svn.sourceforge.net/svnroot/rigsofrods/trunk;
    rev = version;
  }; */
  
  src = fetchurl {
    url = mirror://sourceforge/rigsofrods/rigsofrods/0.37-dev/RoR-0.37.126-Sources.zip;
    sha256 = "03mxmxpfdlsri0j3nqgyj2pc4gpzs8zq8qgg6qhnyazi7j95j4mk";
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
    sed -e "s@/usr/local/lib/OGRE@${ogre}/lib/OGRE@" -i ../bin/plugins.cfg
    sed -e "/CgProgramManager/d" -i ../bin/plugins.cfg
    ensureDir $out/share/rigsofrods
    cp -r .. $out/share/rigsofrods/build-dir
    ensureDir $out/bin
    for i in RoR rorconfig RoRViewer; do
      echo '#! ${stdenv.shell}' >> "$out/bin/$i"
      echo "\"$out/share/rigsofrods/build-dir/bin/$i\"" >> "$out/bin/$i"
      chmod a+x "$out/bin/$i"
    done
  '';

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -langelscript -lgtk-x11-2.0"
    sed -e 's@wxLOCALE_CONV_ENCODING@0@g' -i source/configurator/configurator.cpp
  '';

  # patches = [ ./wx.patch ];

  buildInputs = [ wxGTK29 freeimage cmake zziplib mesa boost pkgconfig
    libuuid lua5 openal ogre ois curl gtk mygui unzip angelscript ];

  meta = {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = http://rigsofrods.sourceforge.net/;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
