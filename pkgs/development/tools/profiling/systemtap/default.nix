{ fetchurl, linuxPackages, makeWrapper, runCommand, fetchgit
, elfutils, pkgconfig, gettext, stow, gnumake }:
let
  ## fetchgit info
  url = git://sourceware.org/git/systemtap.git;
  rev = "51b7cae3023adf137081059c7cc44a13f652ba4c";
  sha256 = "18m3lf11r99f4yr1m172548lghc0i22zqbys1fwlwakbczz0a2lz";

  inherit (linuxPackages) kernel;
  version = kernel.stdenv.lib.substring 0 6 rev;

  ## stap binaries
  stapBuild = kernel.stdenv.mkDerivation {
    name = "systemtap-${version}";
    src = fetchgit { inherit url rev sha256; };
    buildInputs = [ elfutils pkgconfig gettext ];
    enableParallelBuilding = true;
  };

  ## a kernel build dir as expected by systemtap
  kernelBuildDir = runCommand "kbuild-${kernel.version}-merged" {
    buildInputs = [ stow ];
  } ''
    mkdir -p $out
    stowFrom () {
      D="$(dirname $1)"
      P="$(basename $1)"
      shift
      stow -d $D -t $out -v "$@" -S $P
    }
    stowFrom ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build --ignore=source
    ln -s ${kernel.dev}/vmlinux $out/vmlinux
    ln -s ${kernel}/System.map $out/System.map
    ln -s ${kernel.dev}/lib/modules/${kernel.modDirVersion}/source $out/source
  '';

in runCommand "systemtap-${kernel.version}-${version}" {
  inherit stapBuild kernelBuildDir;
  buildInputs = [ makeWrapper ];
  meta = with kernel.stdenv.lib; {
    homepage = https://sourceware.org/systemtap/;
    repositories.git = git://sourceware.org/git/systemtap.git;
    description = "SystemTap provides a simple command line interface and scripting language for writing instrumentation for a live running kernel plus user-space applications.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
} ''
  mkdir -p $out/bin
  for bin in $stapBuild/bin/*; do # hello emacs */
    ln -s $bin $out/bin/$(basename $bin)
  done
  rm $out/bin/stap
  makeWrapper $stapBuild/bin/stap $out/bin/stap \
    --add-flags "-r $kernelBuildDir" \
    --prefix PATH : ${kernel.stdenv.cc.cc}/bin:${elfutils}/bin:${gnumake}/bin
''
