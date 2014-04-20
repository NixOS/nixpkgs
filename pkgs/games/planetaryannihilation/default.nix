{ stdenv, config, fetchurl, patchelf, makeWrapper, xlibs, gtk, glib, udev, alsaLib, atk
, nspr, fontconfig, cairo, pango, nss, freetype, gnome3, gdk_pixbuf, curl, systemd, xorg }:

# TODO: use dynamic attributes once Nix 1.7 is out
assert ((config.planetary_annihilation or null).url or null) != null;
assert ((config.planetary_annihilation or null).sha256 or null) != null;

/* to setup:
 $ cat ~/.nixpkgs/config.nix
 {
  planetary_annihilation = {
    url = "file:///home/user/PA_Linux_62857.tar.bz2";
    sha256 = "0imi3k5144dsn3ka9khx3dj76klkw46ga7m6rddqjk4yslwabh3k";
  };
}
*/

stdenv.mkDerivation {
  name = "planetary-annihalation";

  src = fetchurl {
    inherit (config.planetary_annihilation) url sha256;
  };

  buildInputs = [ patchelf makeWrapper ];
 
  installPhase = ''
    mkdir -p $out/{bin,lib}

    cp -R * $out/
    mv $out/*.so $out/lib
    rm $out/libstdc++.so.6
    ln -s $out/PA $out/bin/PA

    ln -s ${systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" "$out/PA"
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc xlibs.libXdamage xorg.libXfixes gtk glib stdenv.glibc "$out" xlibs.libXext pango udev xlibs.libX11 xlibs.libXcomposite alsaLib atk nspr fontconfig cairo pango nss freetype gnome3.gconf gdk_pixbuf xlibs.libXrender ]}:{stdenv.gcc.gcc}/lib64:${stdenv.glibc}/lib64" "$out/host/CoherentUI_Host.bin" 

    wrapProgram $out/PA --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc stdenv.glibc xlibs.libX11 xlibs.libXcursor gtk glib curl "$out" ]}:${stdenv.gcc.gcc}/lib64:${stdenv.glibc}/lib64"

    for f in $out/lib/*; do
      patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc curl xlibs.libX11 stdenv.glibc xlibs.libXcursor "$out" ]}:${stdenv.gcc.gcc}/lib64:${stdenv.glibc}/lib64" $f
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.uberent.com/pa/;
    description = "next-generation RTS that takes the genre to a planetary scale";
    license = "unfree";
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
