{ pkgs
, stdenv
, dpkg
, patchelf
, makeWrapper
, fetchurl
, bluez
, libX11
, libXtst

# Unified Remote's download page only provides the latest.
#
#  Pass in the version and sha256 to allow easy overriding on updates
#  without waiting for nixpkgs to propagate the changes.
, pkgVersion ? "3.6.0.745"
, pkgSha256 ? "92c1c8828bc9337fa84036cda8a880ed913b81e12a10a8835d034367af2f75a6"

, ... }:


assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  arch = if stdenv.system == "i686-linux"
    then "x86"
    else "x64";
in

stdenv.mkDerivation {
  name = "unified-remote-${pkgVersion}";
  src = fetchurl {
    url = "https://www.unifiedremote.com/download/linux-${arch}-deb";
    sha256 = pkgSha256;
  };

  nativeBuildInputs = [ dpkg patchelf makeWrapper ];
  buildInputs = [ bluez libX11 ];

  buildCommand = ''
    mkdir -p $out
    dpkg -x $src $out
    mv $out/opt/urserver $out/bin
    rmdir $out/opt
    mv $out/bin/urserver-autostart.desktop $out/usr/share/applications

    for name in urserver urserver-autostart; do
      path=$out/usr/share/applications/$name.desktop
      substituteInPlace "$path" --replace /opt/urserver $out/bin
    done

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/urserver

    mkdir $out/lib

    ln -s "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}/libstdc++.so.6" $out/lib/
    ln -s "${stdenv.lib.makeLibraryPath [ bluez ]}/libbluetooth.so.3" $out/lib/
    ln -s "${stdenv.lib.makeLibraryPath [ libX11 ]}/libX11.so.6" $out/lib
    ln -s "${stdenv.lib.makeLibraryPath [ libXtst ]}/libXtst.so.6" $out/lib

    wrapProgram $out/bin/urserver --prefix LD_LIBRARY_PATH : $out/lib

  '';

  meta = with stdenv.lib; {
    homepage = https://www.unifiedremote.com;
    description = "Turn your smartphone into a universal remote control";
    license = licenses.unfree;
    maintainers = [ maintainers.badi ];
    platforms = platforms.unix;
  };

}
