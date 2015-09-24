{ stdenv, config, fetchurl, patchelf, makeWrapper, gtk, glib, udev, alsaLib, atk
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
    ln -s $out/PA $out/bin/PA

    ln -s ${systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/PA"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc xorg.libXdamage xorg.libXfixes gtk glib stdenv.glibc "$out" xorg.libXext pango udev xorg.libX11 xorg.libXcomposite alsaLib atk nspr fontconfig cairo pango nss freetype gnome3.gconf gdk_pixbuf xorg.libXrender ]}:{stdenv.cc.cc}/lib64:${stdenv.glibc}/lib64" "$out/host/CoherentUI_Host" 

    wrapProgram $out/PA --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc stdenv.glibc xorg.libX11 xorg.libXcursor gtk glib curl "$out" ]}:${stdenv.cc.cc}/lib64:${stdenv.glibc}/lib64"

    for f in $out/lib/*; do
      patchelf --set-rpath "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc curl xorg.libX11 stdenv.glibc xorg.libXcursor "$out" ]}:${stdenv.cc.cc}/lib64:${stdenv.glibc}/lib64" $f
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.uberent.com/pa/;
    description = "next-generation RTS that takes the genre to a planetary scale";
    license = stdenv.lib.licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.iElectric ];
  };
}
