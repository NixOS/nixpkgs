{ stdenv, binutils-unwrapped, cctools, llvm }:

# Make sure both underlying packages claim to have prepended their binaries
# with the same targetPrefix.
assert binutils-unwrapped.targetPrefix == cctools.targetPrefix;

let
  inherit (binutils-unwrapped) targetPrefix;
  cmds = [
    "ar" "ranlib" "as" "install_name_tool"
    "ld" "strip" "otool" "lipo" "nm" "strings" "size"
  ];
in

# TODO: loop over targetPrefixed binaries too
stdenv.mkDerivation {
  pname = "${targetPrefix}cctools-binutils-darwin";
  inherit (cctools) version;
  outputs = [ "out" "info" "man" ];
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
    for i in ${stdenv.lib.concatStringsSep " " (builtins.map (e: targetPrefix + e) cmds)}; do
      ln -sf "${cctools}/bin/$i" "$out/bin/$i"
    done

    ln -s ${llvm}/bin/dsymutil $out/bin/dsymutil

    ln -s ${binutils-unwrapped.out}/share $out/share

    ln -s ${cctools}/libexec $out/libexec

    mkdir -p "$info/nix-support" "$man/nix-support"
    printWords ${binutils-unwrapped.info} \
      >> $info/nix-support/propagated-build-inputs
    # FIXME: cctools missing man pages
    printWords ${binutils-unwrapped.man} \
      >> $man/nix-support/propagated-build-inputs
  '';

  passthru = {
    inherit targetPrefix;
  };

  meta = {
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
    priority = 10;
  };
}
