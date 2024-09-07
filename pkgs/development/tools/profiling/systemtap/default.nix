{ lib, fetchgit, pkg-config, gettext, runCommand, makeWrapper
, cpio, elfutils, kernel, gnumake, python3
, nixosTests
}:

let
  ## fetchgit info
  url = "git://sourceware.org/git/systemtap.git";
  rev = "release-${version}";
  sha256 = "sha256-2L7+k/tgI6trkstDTY4xxfFzmNDlxbCHDRKAFaERQeM=";
  version = "5.0a";

  inherit (kernel) stdenv;

  ## stap binaries
  stapBuild = stdenv.mkDerivation {
    pname = "systemtap";
    inherit version;
    src = fetchgit { inherit url rev sha256; };
    nativeBuildInputs = [ pkg-config cpio python3 python3.pkgs.setuptools ];
    buildInputs = [ elfutils gettext python3 ];
    enableParallelBuilding = true;
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=deprecated-declarations" ]; # Needed with GCC 12
  };

  ## symlink farm for --sysroot flag
  sysroot = runCommand "systemtap-sysroot-${kernel.version}" { } ''
    mkdir -p $out/boot $out/usr/lib/debug
    ln -s ${kernel.dev}/vmlinux ${kernel.dev}/lib $out
    ln -s ${kernel.dev}/vmlinux $out/usr/lib/debug
    ln -s ${kernel}/System.map $out/boot/System.map-${kernel.version}
  '';

  pypkgs = with python3.pkgs; makePythonPath [ pyparsing ];

in runCommand "systemtap-${kernel.version}-${version}" {
  inherit stapBuild;
  nativeBuildInputs = [ makeWrapper ];
  passthru.tests = { inherit (nixosTests.systemtap) linux_default linux_latest; };
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
    --add-flags "--sysroot ${sysroot}" \
    --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc stdenv.cc.bintools elfutils gnumake ]}
  makeWrapper $stapBuild/bin/dtrace $out/bin/dtrace \
    --prefix PYTHONPATH : ${pypkgs}
''
