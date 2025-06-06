{
  lib,
  apple-sdk,
  jq,
  llvmPackages,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libcxxabi";
  inherit (apple-sdk) src version;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/include" "$out/lib"
    cp -v "usr/lib/libc++abi.tbd" "$out/lib/libc++abi.tbd"
    cp -v "usr/include/c++/v1/__cxxabi_config.h" "usr/include/c++/v1/cxxabi.h" "$out/include"

    runHook postInstall
  '';

  libName = "cxxabi";

  passthru.build-support = stdenvNoCC.mkDerivation {
    pname = "libcxxabi-build-support";
    inherit (finalAttrs.finalPackage) version;

    srcs = [
      finalAttrs.finalPackage.src
      llvmPackages.libcxx.src
    ];

    sourceRoot = llvmPackages.libcxx.src.name;

    dontConfigure = true;

    nativeBuildInputs = [
      jq
      llvmPackages.llvm
    ];

    buildPhase = ''
      runHook preBuild

      llvm-readtapi ../${lib.escapeShellArg finalAttrs.finalPackage.src.name}/usr/lib/libc++abi.tbd \
        | jq -r '.main_library.exported_symbols[].data | .global + .weak | .[]' > exports
      sort -u exports -o exports

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      for exp in libcxxabi/lib/*.exp; do
        grep -x -f "$exp" < exports > "$out/$(basename "$exp")" || true
      done

      runHook postInstall
    '';
  };
})
