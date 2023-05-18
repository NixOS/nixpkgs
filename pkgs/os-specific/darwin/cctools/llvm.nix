# Create a cctools-compatible bintools that uses equivalent tools from LLVM in place of the ones
# from cctools when possible.

{ lib, stdenv, makeWrapper, cctools-port, llvmPackages, useLLD ? false }:

let
  # `lipo` crashes when running the LLVM test suite when building a fat bundle. This is fixed in LLVM 16.
  # See https://github.com/llvm/llvm-project/issues/59535
  use_llvm_lipo = lib.versionAtLeast llvmPackages.release_version "16";

  llvm_bins = [
    "bitcode_strip"
    "dwarfdump"
    "nm"
    "objdump"
    "otool"
    "ranlib"
    "size"
    "strings"
    "strip"
  ] ++ lib.optional use_llvm_lipo "lipo";

  # Only include the tools that LLVM doesn’t provide and that are present normally on Darwin.
  cctools_bins = [
    "cmpdylib"
    "codesign_allocate"
    "ctf_insert"
    "install_name_tool"
    "libtool"
    "nmedit"
    "pagestuff"
    "segedit"
    "vtool"
  ] ++ lib.optional (! use_llvm_lipo) "lipo";

  ld_path = if useLLD
    then "${lib.getBin llvmPackages.lld}/bin/ld64"
    else "${lib.getBin cctools-port}/bin/ld";

  inherit (stdenv.cc) targetPrefix;
in
stdenv.mkDerivation {
  pname = "cctools-llvm-${if useLLD then "lld" else "ld64"}";
  version = llvmPackages.release_version;

  nativeBuildInputs = [ makeWrapper ];

  outputs = [ "out" "dev" "man" ];

  buildCommand = ''
    mkdir -p "$out/bin"
    ln -s "${lib.getDev cctools-port}" "$dev"
    ln -s "${lib.getMan cctools-port}" "$man" # FIXME

    # Use the clang-integrated assembler instead of using `as` from cctools.
    makeWrapper "${lib.getBin llvmPackages.clang-unwrapped}/bin/clang" "$out/bin/${targetPrefix}as" \
      --add-flags "-x assembler -integrated-as -c"

    ln -s "${lib.getBin llvmPackages.bintools-unwrapped}/bin/llvm-ar" "$out/bin/${targetPrefix}ar"

    for tool in ${toString llvm_bins}; do
      llvmTool=''${tool/_/-}
      ln -s "${lib.getBin llvmPackages.llvm}/bin/llvm-$llvmTool" "$out/bin/${targetPrefix}$tool"
    done

    # llvm-libtool-darwin is not yet capable of being a drop-in replacement for libtool when used with xcbuild.
    # ln -s "${lib.getBin llvmPackages.llvm}/bin/llvm-libtool-darwin" "$out/bin/${targetPrefix}libtool"

    # Don’t use `install_name_tool` from LLVM for now because it causes the build of darwin.CF to fail.
    # ln -s "${lib.getBin llvmPackages.llvm}/bin/llvm-objcopy" "$out/bin/${targetPrefix}install_name_tool"

    for tool in ${toString cctools_bins}; do
      ln -s "${lib.getBin cctools-port}/bin/${targetPrefix}$tool" "$out/bin/${targetPrefix}$tool"
    done

    ln -s "${ld_path}" "$out/bin/${targetPrefix}ld"
  '';

  passthru = { inherit targetPrefix; };
}
