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

runCommand "nixpkgs.xctoolchain" {
  nativeBuildInputs = [ makeWrapper ];
} (''
  mkdir -p $out
  install -D ${writeText "ToolchainInfo.plist" (toPlist {} ToolchainInfo)} $out/ToolchainInfo.plist

  mkdir -p $out/usr/include
  mkdir -p $out/usr/lib
  mkdir -p $out/usr/libexec
  mkdir -p $out/usr/share
  mkdir -p $out/usr/bin

  for bin in ${getBin stdenv.cc}/bin/*; do
    ln -s $bin $out/usr/bin
  done

  for bin in ${getBin stdenv.cc.bintools.bintools}/bin/*; do
    if ! [ -e "$out/usr/bin/$(basename $bin)" ]; then
      ln -s $bin $out/usr/bin
    fi
  done

  ln -s ${buildPackages.yacc}/bin/yacc $out/usr/bin/yacc
  ln -s ${buildPackages.yacc}/bin/bison $out/usr/bin/bison
  ln -s ${buildPackages.flex}/bin/flex $out/usr/bin/flex
  ln -s ${buildPackages.flex}/bin/flex++ $out/usr/bin/flex++
  ln -s $out/bin/flex $out/usr/bin/lex

  ln -s ${buildPackages.m4}/bin/m4 $out/usr/bin/m4
  ln -s $out/usr/bin/m4 $out/usr/bin/gm4

  ln -s ${buildPackages.unifdef}/bin/unifdef $out/usr/bin/unifdef
  ln -s ${buildPackages.unifdef}/bin/unifdefall $out/usr/bin/unifdefall

  ln -s ${buildPackages.gperf}/bin/gperf $out/usr/bin/gperf
  ln -s ${buildPackages.indent}/bin/indent $out/usr/bin/indent
  ln -s ${buildPackages.ctags}/bin/ctags $out/usr/bin/ctags
'' + optionalString stdenv.isDarwin ''
  for bin in ${getBin buildPackages.darwin.cctools}/bin/*; do
    if ! [ -e "$out/usr/bin/$(basename $bin)" ]; then
      ln -s $bin $out/usr/bin
    fi
  done

  ln -s ${buildPackages.darwin.bootstrap_cmds}/bin/mig $out/usr/bin
  ln -s ${mkdep-darwin-src} $out/usr/bin/mkdep
'')
