{ stdenv, fetchurl, dpkg, makeWrapper, python3, coreutils, stdenv_32bit, pkgsi686Linux
, file, glxinfo, xorg, xkeyboardconfig, kde4, mesa, alsaLib, zlib, libpulseaudio, dbus }:

let
  version = "0.9.3";

in stdenv.mkDerivation rec {
  name = "shashlik-${version}";
  src = fetchurl {
    url = "http://static.davidedmundson.co.uk/shashlik/shashlik_${version}.deb";
    sha256 = "a0a9daaeea0436ec8bd90b97112694974f7cf121d5a54083244488ff2d86dbaa";
  };

  buildInputs = [ dpkg makeWrapper python3 ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  installPhase = ''
    cd opt/shashlik

    # in all text files replace hardcoded path
    for i in `find . -type f -exec grep -Iq /opt/shashlik {} \; -and -print`
    do
      substituteInPlace $i --replace /opt/shashlik $out/opt/shashlik
    done
    sed -i -e "s|/bin/ls|${coreutils}/bin/ls|" bin/ddms

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" bin/emulator64-x86
    for i in aapt adb
    do
      patchelf --set-interpreter ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2 bin/$i
    done
    patchelf --set-rpath "$out/opt/shashlik/lib:${stdenv.lib.makeLibraryPath [ pkgsi686Linux.zlib ]}" bin/aapt

    patchShebangs .

    mkdir -p $out/bin $out/opt/shashlik
    cp -r * $out/opt/shashlik
    ln -s $out/opt/shashlik/bin/shashlik-* $out/bin

    wrapProgram $out/opt/shashlik/bin/emulator64-x86 \
      --prefix PATH : ${stdenv.lib.makeBinPath [ file glxinfo ]} \
      --suffix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath (with xorg; [ stdenv.cc.cc libX11 libxcb libXau libXdmcp libXext mesa alsaLib zlib libpulseaudio dbus.lib ])} \
      --suffix QT_XKB_CONFIG_ROOT : ${xkeyboardconfig}/share/X11/xkb
    # kdialog dependency
    wrapProgram $out/opt/shashlik/bin/shashlik-install \
      --prefix PATH : ${kde4.kde_baseapps}/bin
  '';

  meta = with stdenv.lib; {
    description = "Runs Android applications on a standard Linux desktop";
    homepage = http://www.shashlik.io/;
    license = licenses.free;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
