# Tested on linux-x86_64.  Might work on linux-i386.  Probably won't work on anything else.

# To use this driver in NixOS, add it to printing.drivers in configuration.nix.
# configuration.nix might look like this when you're done:
# { pkgs, ... }: {
#   printing = {
#     enable = true;
#     drivers = [ pkgs.xerox-phaser-p3250 ];
#   };
#   (more stuff)
# }
# (This advice was tested on the 15th February, 2020.)

# This nix is loosely based on ../samsung/4.01.17.nix

{ stdenv, fetchurl, cups, libusb }:

let
  installationPath = if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64" else "i386";
  appendPath = if stdenv.hostPlatform.system == "x86_64-linux" then "64" else "";
  libPath = stdenv.lib.makeLibraryPath [ cups libusb ] + ":$out/lib:${stdenv.cc.cc.lib}/lib${appendPath}";
in stdenv.mkDerivation rec {
  pname = "xerox_phaser_p3250";
  version = "7-6-09";

  src = fetchurl {
    url = "http://download.support.xerox.com/pub/drivers/3250/drivers/linux/ar/p3250.tar.gz";
    sha256 = "63838e4c1487e9efaebbdb6c83d11e4fc9d7598cc985de785e6a98683d32eb2b";
  };

  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    cd P3250/Linux/${installationPath}
    mkdir -p $out/lib/cups/{backend,filter}
    pushd at_root/usr/lib${appendPath}/cups/backend
    install -Dm755 mfp $out/lib/cups/backend/
    popd
    pushd at_root/usr/lib${appendPath}/cups/filter
    install -Dm755 pscms rastertosamsung* smfpautoconf $out/lib/cups/filter/
    install -Dm755 libscmssc.so libscmssf.so $out/lib/
    popd

    GLOBIGNORE=*.so
    for exe in $out/lib/cups/**/*; do
      echo "Patching $exe"
      patchelf \
        --set-rpath ${libPath} \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $exe
    done
    unset GLOBIGNORE

    install -v at_root/usr/lib${appendPath}/libmfp.so.1.0.1 $out/lib
    pushd $out/lib
    ln -s -f libmfp.so.1.0.1 libmfp.so.1
    ln -s -f libmfp.so.1 libmfp.so
    popd

    for lib in $out/lib/*.so; do
      echo "Patching $lib"
      patchelf \
        --set-rpath ${libPath} \
        $lib
    done

    mkdir -p $out/share/cups/model/xerox
    pushd ../noarch/at_opt/share/ppd
    for i in *.ppd; do
      sed -i $i -e \
        "s,rastertosamsung,$out/lib/cups/filter/rastertosamsung,g; \
         s,pscms,$out/lib/cups/filter/pscms,g; \
         s,smfpautoconf,$out/lib/cups/filter/smfpautoconf,g"
    done;
    cp -r ./* $out/share/cups/model/xerox
    popd
  '';

  meta = with stdenv.lib; {
    description = "Xerox's Linux printing driver for Phaser P3250; includes binaries without source code";
    homepage = http://www.xerox.com/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ brcha ];
  };
}
