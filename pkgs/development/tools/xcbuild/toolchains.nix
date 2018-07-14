{ runCommand, toolchainName, fetchurl, makeWrapper, stdenv
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

runCommand "Toolchains" {
  nativeBuildInputs = [ makeWrapper ];
} (''
  toolchain=$out/XcodeDefault.xctoolchain
  mkdir -p $toolchain

  install -D ${writeText "ToolchainInfo.plist" (toPlist {} ToolchainInfo)} $toolchain/ToolchainInfo.plist

  mkdir -p $toolchain/usr/include
  mkdir -p $toolchain/usr/lib
  mkdir -p $toolchain/usr/libexec
  mkdir -p $toolchain/usr/share
  mkdir -p $toolchain/usr/bin

  for bin in ${getBin stdenv.cc}/bin/*; do
    ln -s $bin $toolchain/usr/bin
  done

  for bin in ${getBin stdenv.cc.bintools.bintools}/bin/*; do
    if ! [ -e "$toolchain/usr/bin/$(basename $bin)" ]; then
      ln -s $bin $toolchain/usr/bin
    fi
  done

  ln -s ${buildPackages.yacc}/bin/yacc $toolchain/usr/bin/yacc
  ln -s ${buildPackages.yacc}/bin/bison $toolchain/usr/bin/bison
  ln -s ${buildPackages.flex}/bin/flex $toolchain/usr/bin/flex
  ln -s ${buildPackages.flex}/bin/flex++ $toolchain/usr/bin/flex++
  ln -s $toolchain/bin/flex $toolchain/usr/bin/lex

  ln -s ${buildPackages.m4}/bin/m4 $toolchain/usr/bin/m4
  ln -s $toolchain/usr/bin/m4 $toolchain/usr/bin/gm4

  ln -s ${buildPackages.unifdef}/bin/unifdef $toolchain/usr/bin/unifdef
  ln -s ${buildPackages.unifdef}/bin/unifdefall $toolchain/usr/bin/unifdefall

  ln -s ${buildPackages.gperf}/bin/gperf $toolchain/usr/bin/gperf
  ln -s ${buildPackages.indent}/bin/indent $toolchain/usr/bin/indent
  ln -s ${buildPackages.ctags}/bin/ctags $toolchain/usr/bin/ctags
'' + optionalString stdenv.isDarwin ''
  for bin in ${getBin buildPackages.darwin.cctools}/bin/*; do
    if ! [ -e "$toolchain/usr/bin/$(basename $bin)" ]; then
      ln -s $bin $toolchain/usr/bin
    fi
  done

  ln -s ${buildPackages.darwin.bootstrap_cmds}/bin/mig $toolchain/usr/bin
  ln -s ${mkdep-darwin-src} $toolchain/usr/bin/mkdep
'')
