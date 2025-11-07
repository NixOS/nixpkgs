{
  # Use the text-based stubs and headers from the latest SDK (currently 15.x). This is safe because
  # using features that are not available on an older deployment target is a hard error.
  apple-sdk_15,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libcxx";
  # Keep this in sync with the corresponding LLVM libc++ version
  # defined as `_LIBCPP_VERSION` in `usr/include/c++/v1/__config`.
  version = "19.1.2+apple-sdk-${apple-sdk_15.version}";
  inherit (apple-sdk_15) src;

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
