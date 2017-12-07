{ stdenv, binutils-raw, cctools
, hostPlatform, targetPlatform
}:

# Make sure both underlying packages claim to have prepended their binaries
# with the same targetPrefix.
assert binutils-raw.targetPrefix == cctools.targetPrefix;

let
  inherit (binutils-raw) targetPrefix;
  cmds = [
    "ar" "ranlib" "as" "dsymutil" "install_name_tool"
    "ld" "strip" "otool" "lipo" "nm" "strings" "size"
  ];
in

# TODO loop over targetPrefixed binaries too
stdenv.mkDerivation {
  name = "${targetPrefix}cctools-binutils-darwin";
  buildCommand = ''
    mkdir -p $out/bin $out/include

    ln -s ${binutils-raw.out}/bin/${targetPrefix}c++filt $out/bin/${targetPrefix}c++filt

    # We specifically need:
    # - ld: binutils doesn't provide it on darwin
    # - as: as above
    # - ar: the binutils one prodices .a files that the cctools ld doesn't like
    # - ranlib: for compatibility with ar
    # - dsymutil: soon going away once it goes into LLVM (this one is fake anyway)
    # - otool: we use it for some of our name mangling
    # - install_name_tool: we use it to rewrite stuff in our bootstrap tools
    # - strip: the binutils one seems to break mach-o files
    # - lipo: gcc build assumes it exists
    # - nm: the gnu one doesn't understand many new load commands
    for i in ${stdenv.lib.concatStringsSep " " (builtins.map (e: targetPrefix + e) cmds)}; do
      ln -sf "${cctools}/bin/$i" "$out/bin/$i"
    done

    # FIXME: this will give us incorrect man pages for bits of cctools
    ln -s ${binutils-raw.out}/share $out/share

    ln -s ${cctools}/libexec $out/libexec
  '';

  passthru = {
    inherit targetPrefix;
  };
}
