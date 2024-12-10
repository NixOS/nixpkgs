# Create a cctools-compatible bintools that uses equivalent tools from LLVM in place of the ones
# from cctools when possible.

{
  lib,
  stdenv,
  makeWrapper,
  cctools-port,
  llvmPackages,
  enableManpages ? stdenv.targetPlatform == stdenv.hostPlatform,
}:

let
  inherit (stdenv) targetPlatform hostPlatform;

  cctoolsVersion = lib.getVersion cctools-port;
  llvmVersion = llvmPackages.release_version;

  # `bitcode_strip` is not available until LLVM 12.
  useLLVMBitcodeStrip = lib.versionAtLeast llvmVersion "12";

  # A compatible implementation of `otool` was not added until LLVM 13.
  useLLVMOtool = lib.versionAtLeast llvmVersion "13";

  # Older versions of `strip` cause problems for the version of `codesign_allocate` available in
  # the version of cctools in nixpkgs. The version of `codesign_allocate` in cctools-1005.2 does
  # not appear to have issues, but the source is not available yet (as of June 2023).
  useLLVMStrip = lib.versionAtLeast llvmVersion "15" || lib.versionAtLeast cctoolsVersion "1005.2";

  # Clang 11 performs an optimization on x86_64 that is sensitive to the presence of debug info.
  # This causes GCC to fail to bootstrap due to object file differences between stages 2 and 3.
  useClangAssembler = lib.versionAtLeast llvmVersion "12" || !stdenv.isx86_64;

  llvm_bins =
    [
      "dwarfdump"
      "nm"
      "objdump"
      "size"
      "strings"
    ]
    ++ lib.optional useLLVMBitcodeStrip "bitcode-strip"
    ++ lib.optional useLLVMOtool "otool"
    ++ lib.optional useLLVMStrip "strip";

  # Only include the tools that LLVM doesn’t provide and that are present normally on Darwin.
  # The only exceptions are the following tools, which should be reevaluated when LLVM is bumped.
  # - install_name_tool (llvm-objcopy): unrecognized linker commands when building open source CF;
  # - libtool (llvm-libtool-darwin): not fully compatible when used with xcbuild; and
  # - lipo (llvm-lipo): crashes when running the LLVM test suite.
  cctools_bins =
    [
      "cmpdylib"
      "codesign_allocate"
      "ctf_insert"
      "install_name_tool"
      "ld"
      "libtool"
      "lipo"
      "nmedit"
      "pagestuff"
      "ranlib"
      "segedit"
      "vtool"
    ]
    ++ lib.optional (!useLLVMBitcodeStrip) "bitcode_strip"
    ++ lib.optional (!useLLVMOtool) "otool"
    ++ lib.optional (!useLLVMStrip) "strip"
    ++ lib.optional (!useClangAssembler) "as";

  targetPrefix = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";

  linkManPages =
    pkg: source: target:
    lib.optionalString enableManpages ''
      sourcePath=${pkg}/share/man/man1/${source}.1.gz
      targetPath=$man/share/man/man1/${target}.1.gz

      if [ -f "$sourcePath" ]; then
        mkdir -p "$(dirname "$targetPath")"
        ln -s "$sourcePath" "$targetPath"
      fi
    '';
in
stdenv.mkDerivation {
  pname = "cctools-llvm";
  version = "${llvmVersion}-${cctoolsVersion}";

  nativeBuildInputs = [ makeWrapper ];

  # The `man` output has to be included unconditionally because darwin.binutils expects it.
  outputs = [
    "out"
    "dev"
    "man"
  ];

  buildCommand =
    ''
      mkdir -p "$out/bin" "$man"
      ln -s ${lib.getDev cctools-port} "$dev"

    ''
    + lib.optionalString useClangAssembler ''
      # Use the clang-integrated assembler instead of using `as` from cctools.
      makeWrapper "${lib.getBin llvmPackages.clang-unwrapped}/bin/clang" "$out/bin/${targetPrefix}as" \
        --add-flags "-x assembler -integrated-as -c"

    ''
    + ''
      ln -s "${lib.getBin llvmPackages.bintools-unwrapped}/bin/${targetPrefix}llvm-ar" "$out/bin/${targetPrefix}ar"
      ${linkManPages llvmPackages.llvm-manpages "llvm-ar" "ar"}

      for tool in ${toString llvm_bins}; do
        cctoolsTool=''${tool/-/_}
        ln -s "${lib.getBin llvmPackages.llvm}/bin/llvm-$tool" "$out/bin/${targetPrefix}$cctoolsTool"
        ${linkManPages llvmPackages.llvm-manpages "llvm-$tool" "$cctoolsTool"}
      done

      for tool in ${toString cctools_bins}; do
        ln -s "${lib.getBin cctools-port}/bin/${targetPrefix}$tool" "$out/bin/${targetPrefix}$tool"
        ${linkManPages (lib.getMan cctools-port) "$tool" "$tool"}
      done

      ${linkManPages (lib.getMan cctools-port) "ld64" "ld64"}
      ${lib.optionalString (!useLLVMOtool) # The actual man page for otool in cctools is llvm-otool
        (linkManPages (lib.getMan cctools-port) "llvm-otool" "llvm-otool")
      }
    '';

  passthru = { inherit targetPrefix; };
}
