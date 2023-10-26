{ lib
, stdenv
, fetchzip
, cairo
, dbus
, fontconfig
, freetype
, glib
, gtk3
, libX11
, libXcursor
, libXext
, libXi
, libXrandr
, libXrender
, libglvnd
, libuuid
, libxcb
, makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glamoroustoolkit";
  version = "1.0.1";

  src = fetchzip {
    url = "https://github.com/feenkcom/gtoolkit-vm/releases/download/v${finalAttrs.version}/GlamorousToolkit-x86_64-unknown-linux-gnu.zip";
    stripRoot = false;
    hash = "sha256-v63sV0HNHSU9H5rhtJcwZCuIXEGe1+BDyxV0/EqBk2E=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/lib
    cp -r $src/bin $src/lib $out/
    cp ${./GlamorousToolkit-GetImage} $out/bin/GlamorousToolkit-GetImage

    runHook postInstall
  '';

preFixup = let
    libPath = lib.makeLibraryPath [
      cairo
      dbus
      fontconfig
      freetype
      glib
      gtk3
      libX11
      libXcursor
      libXext
      libXi
      libXrandr
      libXrender
      libglvnd
      libuuid
      libxcb
      stdenv.cc.cc.lib
    ];
  in ''
    chmod +x $out/lib/*.so
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:$out/lib" \
      $out/bin/GlamorousToolkit $out/bin/GlamorousToolkit-cli
    patchelf --shrink-rpath \
      $out/bin/GlamorousToolkit $out/bin/GlamorousToolkit-cli
    patchelf \
      --set-rpath "${libPath}:$out/lib" \
      $out/lib/*.so
    patchelf --shrink-rpath $out/lib/*.so
    #
    # shrink-rpath gets it wrong for the following libraries,
    # restore the full rpath.
    #
    patchelf \
      --set-rpath "${libPath}:$out/lib" \
      $out/lib/libPharoVMCore.so \
      $out/lib/libWinit.so \
      $out/lib/libPixels.so
    patchelf --set-rpath $out/lib $out/lib/libssl.so

    ln -s $out/lib/libcrypto.so $out/lib/libcrypto.so.1.1
    ln -s $out/lib/libcairo.so $out/lib/libcairo.so.2
    ln -s $out/lib/libgit2.so $out/lib/libgit2.so.1.1
  '';

  meta = {
    homepage = "https://gtoolkit.com";
    description = "The GlamorousToolkit Development Environment";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.akgrant43 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
