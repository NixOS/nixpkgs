{stdenv, writeText, toolchainName, xcbuild, fetchurl
, llvm, cctools, gcc, bootstrap_cmds, binutils
, yacc, flex, m4, unifdef, gperf, indent, ctags, makeWrapper
, xib2nib}:

let

  ToolchainInfo = {
    Identifier = toolchainName;
  };

  # We could pull this out of developer_cmds but it adds an annoying loop if we want to bootstrap and
  # this is just a tiny script so I'm not going to bother
  mkdep-darwin-src = fetchurl {
    url        = "https://opensource.apple.com/source/developer_cmds/developer_cmds-63/mkdep/mkdep.sh";
    sha256     = "0n4wpqfslfjs5zbys5yri8pfi2awyhlmknsf6laa5jzqbzq9x541";
    executable = true;
  };
in

stdenv.mkDerivation {
  name = "nixpkgs.xctoolchain";
  buildInputs = [ xcbuild makeWrapper ];

  ## cctools should build on Linux but it doesn't currently

  buildCommand = ''
    mkdir -p $out
    plutil -convert xml1 -o $out/ToolchainInfo.plist ${writeText "ToolchainInfo.plist" (builtins.toJSON ToolchainInfo)}

    mkdir -p $out/usr/include
    mkdir -p $out/usr/lib
    mkdir -p $out/usr/libexec
    mkdir -p $out/usr/share

    mkdir -p $out/usr/bin
    cd $out/usr/bin
    ln -s ${stdenv.cc}/bin/cpp
    ln -s ${stdenv.cc}/bin/c++
    ln -s ${stdenv.cc}/bin/cc
    ln -s c++ clang++
    ln -s cc clang

    ln -s ${llvm}/bin/llvm-cov
    ln -s ${llvm}/bin/llvm-dsymutil
    ln -s ${llvm}/bin/llvm-dwarfdump
    ln -s ${llvm}/bin/llvm-nm
    ln -s ${llvm}/bin/llvm-objdump
    ln -s ${llvm}/bin/llvm-otool
    ln -s ${llvm}/bin/llvm-profdata
    ln -s ${llvm}/bin/llvm-size

    ln -s ${yacc}/bin/yacc
    ln -s ${yacc}/bin/bison
    ln -s ${flex}/bin/flex
    ln -s ${flex}/bin/flex++

    ln -s flex lex

    ln -s ${m4}/bin/m4
    ln -s m4 gm4

    ln -s ${unifdef}/bin/unifdef
    ln -s ${unifdef}/bin/unifdefall

    ln -s ${gperf}/bin/gperf
    ln -s ${indent}/bin/indent
    ln -s ${ctags}/bin/ctags
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s ${bootstrap_cmds}/bin/mig
    ln -s ${binutils}/bin/lipo

    ln -s ${cctools}/bin/ar
    ln -s ${cctools}/bin/as
    ln -s ${cctools}/bin/nm
    ln -s ${cctools}/bin/nmedit
    ln -s ${cctools}/bin/ld
    ln -s ${cctools}/bin/libtool
    ln -s ${cctools}/bin/strings
    ln -s ${cctools}/bin/strip
    ln -s ${cctools}/bin/install_name_tool
    ln -s ${cctools}/bin/bitcode_strip
    ln -s ${cctools}/bin/codesign_allocate
    ln -s ${cctools}/bin/dsymutil
    ln -s ${cctools}/bin/dyldinfo
    ln -s ${cctools}/bin/otool
    ln -s ${cctools}/bin/unwinddump
    ln -s ${cctools}/bin/size
    ln -s ${cctools}/bin/segedit
    ln -s ${cctools}/bin/pagestuff
    ln -s ${cctools}/bin/ranlib
    ln -s ${cctools}/bin/redo_prebinding

    ln -s ${xib2nib}/bin/ibtool
  '' +
    # No point including the entire gcc closure if we don't already have it
    (if stdenv.cc.isClang then ''
      ln -s ${stdenv.cc.cc.llvm}/bin/llvm-cov gcov
      ln -s ${mkdep-darwin-src}               mkdep
    '' else ''
      ln -s ${gcc}/bin/gcov
      ln -s ${gcc}/bin/mkdep
    '');
}

# other commands in /bin/
#   asa
#   cmpdylib (in cctools)
#   ctf_insert (in cctools)
#   dwarfdump
#   lorder
#   rebase
#   rpcgen (in developer_cmds)
#   what


# swift: see #11463
#   swift
#   swift-compress
#   swift-demangle
#   swift-stdlib-tool
#   swift-update
#   swiftc
