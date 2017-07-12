{ stdenv, fetchurl, gtk2, atk, gdk_pixbuf, glib, pango, fontconfig, zlib, xorg, upx, patchelf }:

let
  dynlibPath = stdenv.lib.makeLibraryPath
    ([ gtk2 atk gdk_pixbuf glib pango fontconfig zlib stdenv.cc.cc.lib ]
    ++ (with xorg; [
      libX11
      libXext
      libXrender
      libXrandr
      libSM
      libXfixes
      libXdamage
      libXcursor
      libXinerama
      libXi
      libXcomposite
      libXxf86vm
    ]));
in
stdenv.mkDerivation rec {
  name    = "jd-gui-${version}";
  version = "0.3.5";

  src = fetchurl {
    url    = "http://jd.benow.ca/jd-gui/downloads/${name}.linux.i686.tar.gz";
    sha256 = "0jrvzs2s836yvqi41c7fq0gfiwf187qg765b9r1il2bjc0mb3dqv";
  };

  nativeBuildInputs = [ upx patchelf ];

  phases = "unpackPhase installPhase";
  unpackPhase = "tar xf ${src}";
  installPhase = ''
    mkdir -p $out/bin
    upx -d jd-gui -o $out/bin/jd-gui

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${dynlibPath} \
      $out/bin/jd-gui
  '';

  meta = {
    description = "Fast Java Decompiler with powerful GUI";
    homepage    = "http://jd.benow.ca/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = [ "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
