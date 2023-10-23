{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bootBash
, gnumake
, gnupatch
, gnused
, gnugrep
, gnutar
, gawk
, gzip
, diffutils
, tinycc
, derivationWithMeta
, bash
, coreutils
}:
let
  inherit (import ./common.nix { inherit lib; }) meta;
  pname = "bash";
  version = "5.2.15";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "132qng0jy600mv1fs95ylnlisx2wavkkgpb19c6kmz7lnmjhjwhk";
  };

  patches = [
    # flush output for generated code
    ./mksignames-flush.patch
  ];
in
bootBash.runCommand "${pname}-${version}" {
  inherit pname version meta;

  nativeBuildInputs = [
    coreutils
    tinycc.compiler
    gnumake
    gnupatch
    gnused
    gnugrep
    gnutar
    gawk
    gzip
    diffutils
  ];

  passthru.runCommand = name: env: buildCommand:
    derivationWithMeta ({
      inherit name buildCommand;
      builder = "${bash}/bin/bash";
      args = [
        "-e"
        (builtins.toFile "bash-builder.sh" ''
          export CONFIG_SHELL=$SHELL
          bash -eux $buildCommandPath
        '')
      ];
      passAsFile = [ "buildCommand" ];

      SHELL = "${bash}/bin/bash";
      PATH = lib.makeBinPath ((env.nativeBuildInputs or []) ++ [
        bash
        coreutils
      ]);
    } // (builtins.removeAttrs env [ "nativeBuildInputs" ]));

  passthru.tests.get-version = result:
    bootBash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/bash --version
      mkdir $out
    '';
} ''
  # Unpack
  tar xzf ${src}
  cd bash-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

  # Configure
  export CC="tcc -B ${tinycc.libs}/lib"
  export AR="tcc -ar"
  export LD=tcc
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --without-bash-malloc

  # Build
  make -j $NIX_BUILD_CORES SHELL=bash

  # Install
  make -j $NIX_BUILD_CORES install
  ln -s bash $out/bin/sh
''
