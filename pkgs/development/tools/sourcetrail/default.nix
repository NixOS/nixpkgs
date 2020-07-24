{ stdenv, fetchurl, autoPatchelfHook
, zlib, expat, dbus, openssl, python3 }:

stdenv.mkDerivation rec {
  pname = "sourcetrail";
  version = "2019.3.46";

  src = fetchurl {
    name = "sourtrail.tar.gz";
    url = "https://www.sourcetrail.com/downloads/${version}/linux/64bit";
    sha256 = "0dnkxr3fijcsbn6pd20lyxhr9ns6ji1c4dffly9s16yq4x9ad5r4";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ zlib expat dbus stdenv.cc.cc openssl python3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt

    mv -v setup/share $out
    mv -v data/gui/icon/logo_1024_1024.png $out/share/icons/sourcetrail.png
    mv -v data/gui/icon/project_256_256.png $out/share/icons/project-sourcetrail.png

    mkdir -p $out/share/sourcetrail/doc
    mv -v README EULA.txt $out/share/sourcetrail/doc
    mv -v plugin $out/share/sourcetrail

    cp -rv . $out/opt

    rm $out/opt/lib/libssl.so
    rm $out/opt/lib/platforms/{libqeglfs.so,libqwebgl.so}
    ln -s ${openssl}/lib/libssl.so $out/opt/lib/libssl.so

    substituteInPlace \
      $out/share/applications/sourcetrail.desktop \
      --replace /usr/bin/ $out/bin/

    cat <<EOF > $out/bin/sourcetrail
    #! ${stdenv.shell} -e

    # XXX: Sourcetrail somehow copies the initial config files into the home
    # directory without write permissions. We currently just copy them
    # ourselves to work around this problem.
    setup_config() {
      local src dst

      [ ! -d ~/.config/sourcetrail ] && mkdir -p ~/.config/sourcetrail
      for src in $out/opt/data/fallback/*; do
        dst=~/.config/sourcetrail/"\$(basename "\$src")"
        if [ ! -e "\$dst" ]; then
          cp -r "\$src" "\$dst"
        fi
      done

      chmod -R u+w ~/.config/sourcetrail
    }

    [ -d "\$HOME" ] && setup_config
    export PATH="\$PATH:${python3}/bin"
    exec "$out/opt/Sourcetrail.sh" "\$@"
    EOF

    chmod +x $out/bin/sourcetrail

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.sourcetrail.com";
    description = "A cross-platform source explorer for C/C++ and Java";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ midchildan ];
  };
}
