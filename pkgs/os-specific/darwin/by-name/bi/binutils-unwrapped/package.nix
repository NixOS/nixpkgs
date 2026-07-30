{
  lib,
  stdenvNoCC,
  cctools,
  clang-unwrapped,
  ld64,
  llvm,
  llvm-manpages,
  makeWrapper,
  enableManpages ? stdenvNoCC.targetPlatform == stdenvNoCC.hostPlatform,
}:

let
  inherit (stdenvNoCC) targetPlatform hostPlatform;
  targetPrefix = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";

  llvm_cmds = [
    "addr2line"
    "ar"
    "c++filt"
    "dwarfdump"
    "dsymutil"
    "nm"
    "objcopy"
    "objdump"
    "otool"
    "size"
    "strings"
    "strip"
  ];

  cctools_cmds = [
    "codesign_allocate"
    "gprof"
    "ranlib"
    # Use the cctools versions because the LLVM ones can crash or fail when the cctools ones don’t.
    # Revisit when LLVM is updated to LLVM 18 on Darwin.
    "lipo"
    "install_name_tool"
  ];

  linkManPages =
    pkg: source: target:
    lib.optionalString enableManpages ''
      sourcePath=${pkg}/share/man/man1/${source}.1.gz
      targetPath=''${!outputMan}/share/man/man1/${target}.1.gz

      if [ -f "$sourcePath" ]; then
        mkdir -p "$(dirname "$targetPath")"
        ln -s "$sourcePath" "$targetPath"
      fi
    '';
in
stdenvNoCC.mkDerivation {
  pname = "${targetPrefix}cctools-binutils-darwin";
  inherit (cctools) version;

  outputs = [ "out" ] ++ lib.optional enableManpages "man";

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin $out/include

    for tool in ${toString llvm_cmds}; do
      # Translate between LLVM and traditional tool names (e.g., `c++filt` versus `cxxfilt`).
      cctoolsTool=''${tool//-/_}
      llvmTool=''${tool//++/xx}

      # Some tools aren’t prefixed (like `dsymutil`).
      llvmPath="${lib.getBin llvm}/bin"
      if [ -e "$llvmPath/llvm-$llvmTool" ]; then
        llvmTool=llvm-$llvmTool
      elif [ -e "$llvmPath/${targetPrefix}$llvmTool" ]; then
        llvmTool=${targetPrefix}$llvmTool
      fi

      # Not all tools are included in the bootstrap tools. Don’t link them if they don’t exist.
      if [ -e "$llvmPath/$llvmTool" ]; then
        ln -s "$llvmPath/$llvmTool" "$out/bin/${targetPrefix}$cctoolsTool"
      fi
      ${linkManPages llvm-manpages "$llvmTool" "$cctoolsTool"}
    done

    for tool in ${toString cctools_cmds}; do
      toolsrc="${lib.getBin cctools}/bin/${targetPrefix}$tool"
      if [ -e "$toolsrc" ]; then
        ln -s "${lib.getBin cctools}/bin/${targetPrefix}$tool" "$out/bin/${targetPrefix}$tool"
      fi
      ${linkManPages (lib.getMan cctools) "$tool" "$tool"}
    done
    ${
      # These are unprefixed because some tools expect to invoke them without it when cross-compiling to Darwin:
      # - clang needs `dsymutil` when building with debug information;
      # - meson needs `lipo` when cross-compiling to Darwin; and
      # - meson also needs `install_name_tool` and `otool` when performing rpath cleanup on installation.
      lib.optionalString (targetPrefix != "") ''
        for bintool in dsymutil install_name_tool lipo otool; do
          ln -s "$out/bin/${targetPrefix}$bintool" "$out/bin/$bintool"
        done
      ''
    }
    # Use the clang-integrated assembler. `as` in cctools is deprecated upstream and no longer built in nixpkgs.
    makeWrapper "${lib.getBin clang-unwrapped}/bin/clang" "$out/bin/${targetPrefix}as" \
      --add-flags "-x assembler -integrated-as -c"

    ln -s '${lib.getBin ld64}/bin/ld' "$out/bin/${targetPrefix}ld"
    ${linkManPages (lib.getMan ld64) "ld" "ld"}
    ${linkManPages (lib.getMan ld64) "ld-classic" "ld-classic"}
    ${linkManPages (lib.getMan ld64) "ld64" "ld64"}
  '';

  __structuredAttrs = true;

  passthru = {
    inherit cctools_cmds llvm_cmds targetPrefix;
    isCCTools = true; # The fact ld64 is used instead of lld is why this isn’t `isLLVM`.
  };

  meta = {
    maintainers = with lib.maintainers; [ reckenrode ];
    priority = 10;
  };
}
