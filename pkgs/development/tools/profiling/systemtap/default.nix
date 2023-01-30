{ lib, fetchgit, pkg-config, gettext, runCommand, makeWrapper
, cpio, elfutils, kernel, gnumake, python3
}:

let
  ## fetchgit info
  url = "git://sourceware.org/git/systemtap.git";
  rev = "release-${version}";
  sha256 = "sha256-3LgqMBCnUG2UmsekaIvV43lBpSPEocEXmFV9WpE7wE0=";
  version = "4.5";

  inherit (kernel) stdenv;

  ## stap binaries
  stapBuild = stdenv.mkDerivation {
    pname = "systemtap";
    inherit version;
    src = fetchgit { inherit url rev sha256; };
    nativeBuildInputs = [ pkg-config cpio python3 python3.pkgs.setuptools ];
    buildInputs = [ elfutils gettext ];
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

  pypkgs = with python3.pkgs; makePythonPath [ pyparsing ];

in runCommand "systemtap-${kernel.version}-${version}" {
  inherit stapBuild kernelBuildDir;
  nativeBuildInputs = [ makeWrapper ];
  meta = {
    homepage = "https://sourceware.org/systemtap/";
    description = "Provides a scripting language for instrumentation on a live kernel plus user-space";
    license = lib.licenses.gpl2;
    platforms = lib.systems.inspect.patterns.isGnu;
  };
} ''
  mkdir -p $out/bin
  for bin in $stapBuild/bin/*; do
    ln -s $bin $out/bin
  done
  rm $out/bin/stap $out/bin/dtrace
  makeWrapper $stapBuild/bin/stap $out/bin/stap \
    --add-flags "-r $kernelBuildDir" \
    --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc stdenv.cc.bintools elfutils gnumake ]}
  makeWrapper $stapBuild/bin/dtrace $out/bin/dtrace \
    --prefix PYTHONPATH : ${pypkgs}
''
