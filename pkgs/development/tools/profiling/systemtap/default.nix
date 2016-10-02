{ fetchgit, pkgconfig, gettext, runCommand, makeWrapper
, elfutils, kernel, gnumake }:
let
  ## fetchgit info
  url = git://sourceware.org/git/systemtap.git;
  rev = "a10bdceb7c9a7dc52c759288dd2e555afcc5184a";
  sha256 = "1kllzfnh4ksis0673rma5psglahl6rvy0xs5v05qkqn6kl7irmg1";
  version = "2016-09-16";

  inherit (kernel) stdenv;
  inherit (stdenv) lib;

  ## stap binaries
  stapBuild = stdenv.mkDerivation {
    name = "systemtap-${version}";
    src = fetchgit { inherit url rev sha256; };
    buildInputs = [ elfutils pkgconfig gettext ];
    enableParallelBuilding = true;
  };

  ## a kernel build dir as expected by systemtap
  kernelBuildDir = runCommand "kbuild-${kernel.version}-merged" { } ''
    mkdir -p $out
    for f in \
        ${kernel}/System.map \
        ${kernel.dev}/vmlinux \
        ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/{*,.*}
    do
      ln -s $(readlink -f $f) $out
    done
  '';

in runCommand "systemtap-${kernel.version}-${version}" {
  inherit stapBuild kernelBuildDir;
  buildInputs = [ makeWrapper ];
  meta = {
    homepage = https://sourceware.org/systemtap/;
    repositories.git = url;
    description = "Provides a scripting language for instrumentation on a live kernel plus user-space";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
} ''
  mkdir -p $out/bin
  for bin in $stapBuild/bin/*; do # hello emacs */
    ln -s $bin $out/bin
  done
  rm $out/bin/stap
  makeWrapper $stapBuild/bin/stap $out/bin/stap \
    --add-flags "-r $kernelBuildDir" \
    --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc elfutils gnumake ]}
''
