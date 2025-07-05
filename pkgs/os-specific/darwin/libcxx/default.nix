{
  apple-sdk,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libcxx";
  inherit (apple-sdk) src version;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/include" "$out/lib"
    cp -v usr/lib/libc++abi.tbd usr/lib/libc++.1.tbd "$out/lib"
    ln -s libc++.1.tbd "$out/lib/libc++.tbd"
    cp -rv usr/include/c++ "$out/include"
    runHook postInstall
  '';

  passthru.isLLVM = true;
})
