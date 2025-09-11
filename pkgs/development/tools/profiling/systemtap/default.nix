{
  lib,
  runCommand,
  makeWrapper,
  cpio,
  boost,
  elfutils,
  kernel,
  gnumake,
  python3,
  nixosTests,
  withStap ? true, # avoid cyclic dependency with glib, reduce closure size substantially
}:

let
  ## fetchgit info
  url = "git://sourceware.org/git/systemtap.git";
  rev = "release-${version}";
  hash = "sha256-W9iJ+hyowqgeq1hGcNQbvPfHpqY0Yt2W/Ng/4p6asxc=";
  version = "5.3";

  inherit (kernel) stdenv;

  ## stap binaries
  stapBuild = stdenv.mkDerivation {
    pname = "systemtap";
    inherit version;
    src = fetchgit { inherit url rev hash; };
    nativeBuildInputs = [
      pkg-config
      cpio
      python3
      python3.pkgs.setuptools
    ];
    buildInputs = [
      boost
      elfutils
      gettext
      python3
    ];
    enableParallelBuilding = true;
  };

  ## symlink farm for --sysroot flag
  sysroot = runCommand "systemtap-sysroot-${kernel.version}" { } ''
    mkdir -p $out/boot $out/usr/lib/debug
    ln -s ${kernel.dev}/vmlinux ${kernel.dev}/lib $out
    ln -s ${kernel.dev}/vmlinux $out/usr/lib/debug
    ln -s ${kernel}/System.map $out/boot/System.map-${kernel.version}
  '';

  pypkgs = with python3.pkgs; makePythonPath [ pyparsing ];

in
runCommand "systemtap-${systemtap-unwrapped.version}"
  {
    stapBuild = systemtap-unwrapped;
    nativeBuildInputs = [ makeWrapper ];
    passthru.tests = { inherit (nixosTests.systemtap) linux_default linux_latest; };
    inherit (systemtap-unwrapped) meta;
  }
  (
    ''
      mkdir -p $out/bin
      for bin in $stapBuild/bin/*; do
        ln -s $bin $out/bin
      done
      rm $out/bin/stap $out/bin/dtrace
      makeWrapper $stapBuild/bin/dtrace $out/bin/dtrace \
        --prefix PYTHONPATH : ${pypkgs}
    ''
    + lib.optionalString withStap ''
      makeWrapper $stapBuild/bin/stap $out/bin/stap \
        --add-flags "--sysroot ${sysroot}" \
        --prefix PATH : ${
          lib.makeBinPath [
            stdenv.cc.cc
            stdenv.cc.bintools
            elfutils
            gnumake
          ]
        }
    ''
  )
