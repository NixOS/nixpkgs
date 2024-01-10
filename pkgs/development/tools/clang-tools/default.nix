{ lib, stdenv, llvmPackages, enableLibcxx ? false }:
# enableLibcxx will use the c++ headers from clang instead of gcc.
# This shouldn't have any effect on platforms that use clang as the default compiler already.

let
  unwrapped = llvmPackages.clang-unwrapped;

in stdenv.mkDerivation {
  inherit unwrapped;

  pname = "clang-tools";
  version = lib.getVersion unwrapped;
  dontUnpack = true;
  clang = if enableLibcxx then llvmPackages.libcxxClang else llvmPackages.clang;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for tool in $unwrapped/bin/clang-*; do
      tool=$(basename "$tool")

      # Compilers have their own derivation, no need to include them here:
      if [[ $tool == "clang-cl" || $tool == "clang-cpp" ]]; then
        continue
      fi

      # Clang's derivation produces a lot of binaries, but the tools we are
      # interested in follow the `clang-something` naming convention - except
      # for clang-$version (e.g. clang-13), which is the compiler again:
      if [[ ! $tool =~ ^clang\-[a-zA-Z_\-]+$ ]]; then
        continue
      fi

      ln -s $out/bin/clangd $out/bin/$tool
    done

    if [[ -z "$(ls -A $out/bin)" ]]; then
      echo "Found no binaries - maybe their location or naming convention changed?"
      exit 1
    fi

    substituteAll ${./wrapper} $out/bin/clangd
    chmod +x $out/bin/clangd

    runHook postInstall
  '';

  meta = unwrapped.meta // {
    description = "Standalone command line tools for C++ development";
    maintainers = with lib.maintainers; [ patryk27 ];
  };
}
