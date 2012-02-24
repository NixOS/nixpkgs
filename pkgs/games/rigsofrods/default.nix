{ fetchsvn, fetchurl, stdenv, wxGTK290, freeimage, cmake, zziplib, mesa, boost, 
  pkgconfig, libuuid, lua5, openal, ogre, ois, curl, gtk, pixman, mygui, unzip,
  angelscript, caelum, ogrepaged, mysocketw, libxcb
  }:

stdenv.mkDerivation rec {
  version = "0.39.4";
  name = "rigsofrods-${version}";

  src = fetchurl {
    url = mirror://sourceforge/rigsofrods/rigsofrods-source-0.39.4.tar.bz2;
    sha256 = "1kpjkski0yllwzdki0rjpqvifjs0fwpgs513y4dv4s9wfwan1qcx";
  };

  contentPackSrc = fetchurl {
    url = mirror://sourceforge/rigsofrods/rigsofrods/0.37/content-pack-0.37.zip;
    sha256 = "0prvn8lxqazadad4mv0nilax9i4vqb9s7dp7mqzvqc0ycmcnf4ps";
  };

  enableParallelBuilding = true;

  cmakeFlags = [
    # "-DROR_USE_LUA=TRUE" "-DLUA_LIBRARIES=${lua5}/lib/liblua.a"
    "-DROR_USE_CURL=TRUE"
    "-DROR_USE_MYGUI=TRUE"
    "-DROR_USE_OPNEAL=TRUE"
    "-DROR_USE_CAELUM=TRUE"
    "-DROR_USE_PAGED=TRUE"
    "-DROR_USE_ANGELSCRIPT=TRUE"
    "-DROR_USE_SOCKETW=TRUE"
  ];
  makeFlags = "VERBOSE=1";

  installPhase = ''
    sed -e "s@/usr/local/lib/OGRE@${ogre}/lib/OGRE@" -i ../tools/linux/binaries/plugins.cfg
    ensureDir $out/share/rigsofrods
    cp -r .. $out/share/rigsofrods/build-dir
    cp ../tools/linux/binaries/plugins.cfg $out/share/rigsofrods/build-dir/bin
    ensureDir $out/bin
    ln -s $out/share/rigsofrods/build-dir/bin/{RoR,rorconfig} $out/bin
    cd $out/share/rigsofrods
    mkdir contentpack
    cd contentpack
    unzip "${contentPackSrc}"

    echo First run rorconfig once to create ~/.rigsofrods
    echo Then copy $out/share/rigsofrods/build-dir/bin/plugins.cfg to ~/.rigsofrods
    echo Then ln $out/share/rigsofrods/contentpack/* to ~/.rigsofrods/packs
  '';

  patches = [ ./doubleslash.patch ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -langelscript -lgtk-x11-2.0"
    sed -e 's@wxLOCALE_CONV_ENCODING@0@g' -i source/configurator/configurator.cpp
  '';

  buildInputs = [ wxGTK290 freeimage cmake zziplib mesa boost pkgconfig
    libuuid lua5 openal ogre ois curl gtk mygui unzip angelscript
    caelum ogrepaged mysocketw libxcb ];

  meta = {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = http://rigsofrods.sourceforge.net/;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = with stdenv.lib.platforms; linux;
  };
}
