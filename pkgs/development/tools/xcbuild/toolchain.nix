{stdenv, writeText, toolchainName, xcbuild
, cc, cctools, llvm, yacc, flex, m4, unifdef, bootstrap_cmds}:

let

  ToolchainInfo = {
    Identifier = toolchainName;
  };

in

stdenv.mkDerivation {
  name = "nixpkgs.xctoolchain";
  buildInputs = [ xcbuild ];
  propagatedBuildInputs = [ cc cctools llvm ];
  buildCommand = ''
    mkdir -p $out
    /usr/bin/plutil -convert xml1 -o $out/ToolchainInfo.plist ${writeText "ToolchainInfo.plist" (builtins.toJSON ToolchainInfo)}

    mkdir -p $out/usr/include
    mkdir -p $out/usr/lib
    mkdir -p $out/usr/libexec
    mkdir -p $out/usr/share

    mkdir -p $out/usr/bin
    cd $out/usr/bin
    ln -s ${cc}/bin/cpp
    ln -s ${cc}/bin/c++
    ln -s ${cc}/bin/cc
    ln -s cc clang
    ln -s c++ clang++
    ln -s cc c89
    ln -s cc c99

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

    ln -s ${bootstrap_cmds}/bin/mig
  '';
}

# other commands in /bin/
#   asa
#   cmpdylib
#   ctags
#   ctf_insert
#   dwarfdump
#   gcov
#   gperf
#   indent
#   lipo
#   lorder
#   mkdep
#   rebase
#   rpcgen
#   swift
#   swift-compress
#   swift-demangle
#   swift-stdlib-tool
#   swift-update
#   swiftc
#   what
