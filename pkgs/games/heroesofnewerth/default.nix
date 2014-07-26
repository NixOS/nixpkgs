{ stdenv, fetchurl, buildEnv, makeWrapper, unzip, xlibs, ncurses, libxml2
, freetype, zlib, glibc, fontconfig, atk, glib, pango, gdk_pixbuf, cairo
, nss, nspr, gnome3, alsaLib, dbus_glib, bzip2, mesa, gnome
}:

let
  libPath = stdenv.lib.makeLibraryPath [
      stdenv.gcc.gcc xlibs.libX11 xlibs.libXrender xlibs.libXdmcp xlibs.libXau xlibs.libxcb xlibs.libXext xlibs.libXScrnSaver
      freetype glibc fontconfig gnome.gtk
];
  ld_libs = stdenv.lib.makeLibraryPath [
      zlib libxml2 gnome.gtk atk glib pango ncurses gdk_pixbuf cairo nss
      nspr gnome3.gconf alsaLib dbus_glib xlibs.libXScrnSaver bzip2 mesa
];
  binary = if stdenv.is64bit then "hon-x86_64" else "hon-x86";
in
assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "HeroesOfNewerth-${version}";
  version = "3.4.3";

  src = 
      fetchurl {
        name = "HoNClient-${version}.sh";
        url = http://dl.heroesofnewerth.com/HoNClient-3.4.3.sh;
        sha256 = "ccc6c024fe1e2b35a6a8f0310c33b875e13bec41e9e8b5af8fa371e54347328b";
      };

  buildInputs = [ makeWrapper unzip ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cd $out
    # don't know why, but unzip fails with error code 1
    unzip $src || echo ""
    mkdir bin
    patchelf \
      --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${stdenv.gcc.gcc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
      $out/data/${binary}

    makeWrapper $out/data/${binary} $out/bin/hon \
      --prefix "LD_LIBRARY_PATH" : "$out/data:$out/data/libs-x86_64:${ld_libs}"
  '';

  meta = with stdenv.lib; {
    description = "A multiplayer online battle arena (MOBA) video game";
    homepage = http://www.heroesofnewerth.com/;
    license = [ licenses.unfree ];
    maintainers = [ maintainers.offline ];
  };
}
