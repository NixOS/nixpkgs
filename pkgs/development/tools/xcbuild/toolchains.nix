{ runCommand, toolchainName, fetchurl, stdenv
, buildPackages, lib, writeText }:

let

  inherit (lib) getBin optionalString;
  inherit (lib.generators) toPlist;

  ToolchainInfo = {
    Identifier = toolchainName;
  };

  # We could pull this out of developer_cmds but it adds an annoying
  # loop if we want to bootstrap and this is just a tiny script so I'm
  # not going to bother.
  mkdep-darwin-src = fetchurl {
    url        = "https://opensource.apple.com/source/developer_cmds/developer_cmds-63/mkdep/mkdep.sh";
    sha256     = "0n4wpqfslfjs5zbys5yri8pfi2awyhlmknsf6laa5jzqbzq9x541";
    executable = true;
  };
in

runCommand "Toolchains" {} (''
  toolchain=$out/XcodeDefault.xctoolchain
  mkdir -p $toolchain

  install -D ${writeText "ToolchainInfo.plist" (toPlist {} ToolchainInfo)} $toolchain/ToolchainInfo.plist

  ln -s $toolchain $toolchain/usr

  mkdir -p $toolchain/include
  mkdir -p $toolchain/lib
  mkdir -p $toolchain/libexec
  mkdir -p $toolchain/share
  mkdir -p $toolchain/bin

  for bin in ${getBin stdenv.cc}/bin/*; do
    ln -s $bin $toolchain/bin
  done

  for bin in ${getBin stdenv.cc.bintools.bintools}/bin/*; do
    if ! [ -e "$toolchain/bin/$(basename $bin)" ]; then
      ln -s $bin $toolchain/bin
    fi
  done

  ln -s ${buildPackages.bison}/bin/yacc $toolchain/bin/yacc
  ln -s ${buildPackages.bison}/bin/bison $toolchain/bin/bison
  ln -s ${buildPackages.flex}/bin/flex $toolchain/bin/flex
  ln -s ${buildPackages.flex}/bin/flex++ $toolchain/bin/flex++
  ln -s $toolchain/bin/flex $toolchain/bin/lex

  ln -s ${buildPackages.m4}/bin/m4 $toolchain/bin/m4
  ln -s $toolchain/bin/m4 $toolchain/bin/gm4

  ln -s ${buildPackages.unifdef}/bin/unifdef $toolchain/bin/unifdef
  ln -s ${buildPackages.unifdef}/bin/unifdefall $toolchain/bin/unifdefall

  ln -s ${buildPackages.gperf}/bin/gperf $toolchain/bin/gperf
  ln -s ${buildPackages.indent}/bin/indent $toolchain/bin/indent
  ln -s ${buildPackages.ctags}/bin/ctags $toolchain/bin/ctags
'' + optionalString stdenv.hostPlatform.isDarwin ''
  for bin in ${getBin buildPackages.cctools}/bin/*; do
    if ! [ -e "$toolchain/bin/$(basename $bin)" ]; then
      ln -s $bin $toolchain/bin
    fi
  done

  ln -s ${buildPackages.darwin.bootstrap_cmds}/bin/mig $toolchain/bin
  mkdir -p $toolchain/libexec
  ln -s ${buildPackages.darwin.bootstrap_cmds}/libexec/migcom $toolchain/libexec
  ln -s ${mkdep-darwin-src} $toolchain/bin/mkdep
'')
