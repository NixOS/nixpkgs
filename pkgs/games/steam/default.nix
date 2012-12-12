{ stdenv, fetchurl, dpkg, makeWrapper, xz, libX11, gcc, glibc215
, libselinux, libXrandr, pango, freetype, fontconfig, glib, gtk
, gdk_pixbuf, cairo, libXi, alsaLib, libXrender, nss, nspr, zlib
, dbus, libpng12, libXfixes, cups, libgcrypt, openal, pulseaudio
, patchelf }:

assert stdenv.system == "i686-linux";

let version = "1.0.0.16"; in

stdenv.mkDerivation rec {
  name = "steam-${version}";

  src = fetchurl {
    url = "http://media.steampowered.com/client/installer/steam.deb";
    sha256 = "0mx92f9hjjpg3blgmgp8sz0f3jg7m9hssdscipwybks258k8926m";
  };

  buildInputs = [ dpkg makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x $src $out
    mv $out/usr/* $out/
    rmdir $out/usr
    substituteInPlace "$out/bin/steam" --replace "/bin/bash" "/bin/sh"
    substituteInPlace "$out/bin/steam" --replace "/usr/" "$out/"
    substituteInPlace "$out/bin/steam" --replace "\`basename \$0\`" "steam"
    sed -i '/jockey-common/d' $out/bin/steam
    wrapProgram "$out/bin/steam" \
      --prefix PATH ":" "${xz}/bin" \
      --prefix LD_LIBRARY_PATH : ${libX11}/lib:${gcc.gcc}/lib:${glibc215}/lib:${libselinux}/lib:${libXrandr}/lib:${pango}/lib:${freetype}/lib:${fontconfig}/lib:${glib}/lib:${gtk}/lib:${gdk_pixbuf}/lib:${cairo}/lib:${libXi}/lib:${alsaLib}/lib:${libXrender}/lib:${nss}/lib:${nspr}/lib:${zlib}/lib:${dbus}/lib:${libpng12}/lib:${libXfixes}/lib:${cups}/lib:${libgcrypt}/lib:${openal}/lib:${pulseaudio}/lib

    mkdir -p $out/patches
    cat > $out/patches/post-install.sh << EOF
    #!${stdenv.shell}

    # post-install script to patch stuff at \$HOME
    PATH=\$PATH:${patchelf}/bin
    sed -i 's/bash/sh/' \$HOME/.local/share/Steam/steam.sh
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        \$HOME/.local/share/Steam/ubuntu12_32/steam
    EOF

    chmod +x $out/patches/post-install.sh
  '';

  meta = {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = "unfree";
  };
}
