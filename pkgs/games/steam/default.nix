/*{ stdenv, fetchurl, dpkg, makeWrapper, xz, libX11, gcc, glibc
, libselinux, libXrandr, pango, freetype, fontconfig, glib, gtk
, gdk_pixbuf, cairo, libXi, alsaLib, libXrender, nss, nspr, zlib
, dbus, libpng12, libXfixes, cups, libgcrypt, openal, pulseaudio
, libxcb, libXau, libXdmcp, flashplayer, libSM, libICE, libXext
, dbus_glib, libusb1, networkmanager
, SDL # World of Goo
, libvorbis # Osmos
, curl, mesa # Superbrothers: S&S EP
, patchelf }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let version = "1.0.0.39"; in

stdenv.mkDerivation rec {
  name = "steam-${version}";

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/steam-launcher_${version}_all.deb";
    sha256 = "1z1cnlr2qw2ndnqsfwjck9617m2p0f3p9q9409vczj909h2a9wyk";
  };

  buildInputs = [ dpkg makeWrapper ];

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x $src $out
    cp -r $out/usr/* $out/
    rm -rf $out/usr
    substituteInPlace "$out/bin/steam" --replace "/usr/bin/env bash" "/bin/sh"
    substituteInPlace "$out/bin/steam" --replace "/usr/" "$out/"
    sed -i 's,STEAMPACKAGE=.*,STEAMPACKAGE=steam,' $out/bin/steam
    sed -i '/STEAMSCRIPT/d' $out/bin/steam

    mv $out/bin/steam $out/bin/.steam-wrapped
    cat > $out/bin/steam << EOF

    export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${libX11}/lib:${gcc.gcc}/lib:${libselinux}/lib:${libXrandr}/lib:${pango}/lib:${freetype}/lib:${fontconfig}/lib:${glib}/lib:${gtk}/lib:${gdk_pixbuf}/lib:${cairo}/lib:${libXi}/lib:${alsaLib}/lib:${libXrender}/lib:${nss}/lib:${nspr}/lib:${zlib}/lib:${dbus}/lib:${libpng12}/lib:${libXfixes}/lib:${cups}/lib:${libgcrypt}/lib:${openal}/lib:${pulseaudio}/lib:${libxcb}/lib:${libXau}/lib:${libXdmcp}/lib:${SDL}/lib:${libvorbis}/lib:${curl}/lib:${libSM}/lib:${libICE}/lib:${dbus_glib}/lib:${networkmanager}/lib:${libXext}/lib:${libusb1}/lib
    STEAMBOOTSTRAP=~/.steam/steam/steam.sh
    if [ -f \$STEAMBOOTSTRAP ]; then
      PLATFORM32=ubuntu12_32
      STEAMCONFIG=~/.steam
      STEAMROOT=~/.local/share/Steam
      STEAMDATA="\$STEAMROOT"
      PIDFILE="\$STEAMCONFIG/steam.pid"
      STEAMBIN32LINK="\$STEAMCONFIG/bin32"
      STEAMBIN64LINK="\$STEAMCONFIG/bin64"
      STEAMSDK32LINK="\$STEAMCONFIG/sdk32"
      STEAMSDK64LINK="\$STEAMCONFIG/sdk64"
      STEAMROOTLINK="\$STEAMCONFIG/root"
      STEAMDATALINK="\$STEAMCONFIG/steam"
      STEAMSTARTING="\$STEAMCONFIG/starting"
      # Create symbolic links for the Steam API
      if [ ! -e "\$STEAMCONFIG" ]; then
          mkdir "\$STEAMCONFIG"
      fi
      if [ "\$STEAMROOT" != "\$STEAMROOTLINK" -a "\$STEAMROOT" != "\$STEAMDATALINK" ]; then
          rm -f "\$STEAMBIN32LINK" && ln -s "\$STEAMROOT/\$PLATFORM32" "\$STEAMBIN32LINK"
          rm -f "\$STEAMBIN64LINK" && ln -s "\$STEAMROOT/\$PLATFORM64" "\$STEAMBIN64LINK"
          rm -f "\$STEAMSDK32LINK" && ln -s "\$STEAMROOT/linux32" "\$STEAMSDK32LINK"
          rm -f "\$STEAMSDK64LINK" && ln -s "\$STEAMROOT/linux64" "\$STEAMSDK64LINK"
          rm -f "\$STEAMROOTLINK" && ln -s "\$STEAMROOT" "\$STEAMROOTLINK"
          if [ "\$STEAMDATALINK" ]; then
              rm -f "\$STEAMDATALINK" && ln -s "\$STEAMDATA" "\$STEAMDATALINK"
          fi
      fi
      # Temporary bandaid until everyone has the new libsteam_api.so
      rm -f ~/.steampath && ln -s "\$STEAMCONFIG/bin32/steam" ~/.steampath
      rm -f ~/.steampid && ln -s "\$PIDFILE" ~/.steampid
      rm -f ~/.steam/bin && ln -s "\$STEAMBIN32LINK" ~/.steam/bin
      export LD_LIBRARY_PATH="\$STEAMBIN32LINK:\$LD_LIBRARY_PATH:${mesa}/lib"
      export SDL_VIDEO_X11_DGAMOUSE=0
      cd "\$STEAMROOT"
      FLASHLINK="\$STEAMCONFIG/bin32/plugins"
      rm -f "\$FLASHLINK" && ln -s "${flashplayer}/lib/mozilla/plugins" "\$FLASHLINK"
      LDSO="\$STEAMBIN32LINK/ld.so"
      cp ${glibc}/lib/ld-linux.so.2 "\$LDSO"
      chmod u+w "\$LDSO"
      echo \$\$ > "\$PIDFILE" # pid of the shell will become pid of steam
      export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${glibc}/lib
      exec "\$LDSO" "\$STEAMBIN32LINK/steam"
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
    license = stdenv.lib.licenses.unfree;
  };
}
*/

{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "steam-1.0.0.48";
  src = fetchurl {
    url = http://repo.steampowered.com/steam/pool/steam/s/steam/steam_1.0.0.48.tar.gz;
    sha256 = "08y5qf75ssk4fnazyv2yz1c5zs7gjiwigaibv8yz1gbr290r0b52";
  };
  installPhase = ''
    make DESTDIR=$out install
    mv $out/usr/* $out #*/
    rmdir $out/usr
  '';
  
  meta = {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = stdenv.lib.licenses.unfree;
  };
}
