{ lib, stdenv, makeWrapper, binutils-unwrapped, cctools, llvm, clang-unwrapped }:

# Make sure both underlying packages claim to have prepended their binaries
# with the same targetPrefix.
assert binutils-unwrapped.targetPrefix == cctools.targetPrefix;

let
  inherit (binutils-unwrapped) targetPrefix;
  cmds = [
    "ar" "ranlib" "as" "install_name_tool"
    "ld" "strip" "otool" "lipo" "nm" "strings" "size"
    "codesign_allocate"
  ];
in

# TODO: loop over targetPrefixed binaries too
stdenv.mkDerivation {
  pname = "${targetPrefix}cctools-binutils-darwin";
  inherit (cctools) version;
  outputs = [ "out" "man" ];
  buildCommand = ''
    mkdir -p $out/bin $out/include

    ln -s ${binutils-unwrapped.out}/bin/${targetPrefix}c++filt $out/bin/${targetPrefix}c++filt

    # We specifically need:
    # - ld: binutils doesn't provide it on darwin
    # - as: as above
    # - ar: the binutils one produces .a files that the cctools ld doesn't like
    # - ranlib: for compatibility with ar
    # - otool: we use it for some of our name mangling
    # - install_name_tool: we use it to rewrite stuff in our bootstrap tools
    # - strip: the binutils one seems to break mach-o files
    # - lipo: gcc build assumes it exists
    # - nm: the gnu one doesn't understand many new load commands
    for i in ${lib.concatStringsSep " " (builtins.map (e: targetPrefix + e) cmds)}; do
      ln -sf "${cctools}/bin/$i" "$out/bin/$i"
    done

    ln -s ${llvm}/bin/dsymutil $out/bin/dsymutil

    ln -s ${binutils-unwrapped.out}/share $out/share

    ln -s ${cctools}/libexec $out/libexec

    mkdir -p "$man"/share/man/man{1,5}
    for i in ${builtins.concatStringsSep " " cmds}; do
      for path in "${cctools.man}"/share/man/man?/$i.*; do
        dest_path="$man''${path#${cctools.man}}"
        ln -sv "$path" "$dest_path"
      done
    done
  ''
  # On aarch64-darwin we must use clang, because "as" from cctools just doesn't
  # handle the arch. Proxying calls to clang produces quite a bit of warnings,
  # and using clang directly here is a better option than relying on cctools.
  # On x86_64-darwin the Clang version is too old to support this mode.
  + lib.optionalString stdenv.isAarch64 ''
    rm $out/bin/${targetPrefix}as
    makeWrapper "${clang-unwrapped}/bin/clang" "$out/bin/${targetPrefix}as" \
      --add-flags "-x assembler -integrated-as -c"
  '';

  nativeBuildInputs = lib.optionals stdenv.isAarch64 [ makeWrapper ];

  passthru = {
    inherit targetPrefix;
  };

  meta = {
    maintainers = with lib.maintainers; [ matthewbauer ];
    priority = 10;
  };
}
