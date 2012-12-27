{ stdenv, fetchurl, dpkg, makeWrapper, xz, libX11, gcc, glibc215
, libselinux, libXrandr, pango, freetype, fontconfig, glib, gtk
, gdk_pixbuf, cairo, libXi, alsaLib, libXrender, nss, nspr, zlib
, dbus, libpng12, libXfixes, cups, libgcrypt, openal, pulseaudio
, SDL # World of Goo
, libvorbis # Osmos
, curl # Superbrothers: S&S EP
, patchelf }:

assert stdenv.system == "i686-linux";

let version = "1.0.0.18"; in

stdenv.mkDerivation rec {
  name = "steam-${version}";

  src = fetchurl {
    url = "http://media.steampowered.com/client/installer/steam.deb";
    sha256 = "1gzfyh3wfdb4h7cxibx61c31l8pjz5zcp5d9d5w9jyja463lv49c";
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

    mv $out/bin/steam $out/bin/.steam-wrapped
    cat > $out/bin/steam << EOF
    #!${stdenv.shell}

    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${libX11}/lib:${gcc.gcc}/lib:${glibc215}/lib:${libselinux}/lib:${libXrandr}/lib:${pango}/lib:${freetype}/lib:${fontconfig}/lib:${glib}/lib:${gtk}/lib:${gdk_pixbuf}/lib:${cairo}/lib:${libXi}/lib:${alsaLib}/lib:${libXrender}/lib:${nss}/lib:${nspr}/lib:${zlib}/lib:${dbus}/lib:${libpng12}/lib:${libXfixes}/lib:${cups}/lib:${libgcrypt}/lib:${openal}/lib:${pulseaudio}/lib:${SDL}/lib:${libvorbis}/lib:${curl}/lib
    STEAMBOOTSTRAP=\$HOME/.steam/steam/steam.sh
    if [ -f \$STEAMBOOTSTRAP ]; then
      STEAMCONFIG=~/.steam
      STEAMROOT="\$STEAMCONFIG/steam"
      STEAMBINDIR="\$STEAMROOT/ubuntu12_32"
      PIDFILE="\$STEAMCONFIG/steam.pid"
      STEAMRUNCMD="\$STEAMCONFIG/runcmd"
      STEAMBIN32LINK="\$STEAMCONFIG/bin32"
      STEAMBIN64LINK="\$STEAMCONFIG/bin64"
      STEAMROOTLINK="\$STEAMCONFIG/root"
      STEAMSTARTING="\$STEAMCONFIG/starting"
      export LD_LIBRARY_PATH="\$STEAMBINDIR:\$LD_LIBRARY_PATH"
      export SDL_VIDEO_X11_DGAMOUSE=0
      cd "\$STEAMROOT"
      cp ${glibc215}/lib/ld-linux.so.2 "\$STEAMBINDIR"
      chmod u+w "\$STEAMBINDIR/ld-linux.so.2"
      echo \$\$ > "\$PIDFILE" # pid of the shell will become pid of steam
      exec "\$STEAMBINDIR/ld-linux.so.2" "\$STEAMBINDIR/steam"
    else
      export PATH=${xz}/bin:\$PATH
      exec $out/bin/.steam-wrapped
    fi
    EOF

    chmod +x $out/bin/steam
  '';

  meta = {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = "unfree";
  };
}
