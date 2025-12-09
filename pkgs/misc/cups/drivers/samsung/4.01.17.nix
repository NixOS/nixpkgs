# Tested on linux-x86_64.  Might work on linux-i386.  Probably won't work on anything else.

# To use this driver in NixOS, add it to printing.drivers in configuration.nix.
# configuration.nix might look like this when you're done:
# { pkgs, ... }: {
#   printing = {
#     enable = true;
#     drivers = [ pkgs.samsung-unified-linux-driver_4_01_17 ];
#   };
#   (more stuff)
# }
# (This advice was tested on the 1st November 2016.)

{
  lib,
  stdenv,
  cups,
  libusb-compat-0_1,
  fetchurl,
  patchPpdFilesHook,
}:

# Do not bump lightly! Visit <http://www.bchemnet.com/suldr/supported.html>
# to see what will break when upgrading. Consider a new versioned attribute.
let
  installationPath = if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64" else "i386";
  appendPath = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") "64";
  libPath =
    lib.makeLibraryPath [
      cups
      libusb-compat-0_1
    ]
    + ":$out/lib:${lib.getLib stdenv.cc.cc}/lib";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "samsung-unified-linux-driver";
  version = "4.01.17";

  src = fetchurl {
    url = "http://www.bchemnet.com/suldr/driver/UnifiedLinuxDriver-${finalAttrs.version}.tar.gz";
    sha256 = "1vv3pzvqpg1dq3xjr8161x2yp3v7ca75vil56ranhw5pkjwq66x0";
  };

  nativeBuildInputs = [ patchPpdFilesHook ];

  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    cd Linux/${installationPath}
    mkdir -p $out/lib/cups/{backend,filter}
    install -Dm755 mfp $out/lib/cups/backend/
    install -Dm755 pstosecps pstospl pstosplc rastertospl rastertosplc $out/lib/cups/filter/
    install -Dm755 libscmssc.so $out/lib/

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
    cd $out/lib
    ln -s -f libmfp.so.1.0.1 libmfp.so.1
    ln -s -f libmfp.so.1 libmfp.so

    for lib in $out/lib/*.so; do
      echo "Patching $lib"
      patchelf \
        --set-rpath ${libPath} \
        $lib
    done

    mkdir -p $out/share/cups/model/samsung
    cd -
    cd ../noarch/at_opt/share/ppd
    cp -r ./* $out/share/cups/model/samsung

    runHook postInstall
  '';

  ppdFileCommands = [
    "pstosecps"
    "pstospl"
    "pstosplc"
    "rastertospl"
  ];

  meta = {
    description = "Samsung's Linux printing drivers; includes binaries without source code";
    homepage = "http://www.samsung.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ joko ];
  };
})
