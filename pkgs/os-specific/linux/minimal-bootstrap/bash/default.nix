{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bootBash,
  gnumake,
  gnupatch,
  gnused,
  gnugrep,
  gnutar,
  gawk,
  gzip,
  diffutils,
  tinycc,
  derivationWithMeta,
  bash,
  coreutils,
}:
let
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
bootBash.runCommand "${pname}-${version}"
  {
    inherit pname version;

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

    passthru.runCommand =
      name: env: buildCommand:
      derivationWithMeta (
        {
          inherit name buildCommand;
          builder = "${bash}/bin/bash";
          args = [
            "-e"
            (builtins.toFile "bash-builder.sh" ''
              export CONFIG_SHELL=$SHELL

              # Normalize the NIX_BUILD_CORES variable. The value might be 0, which
              # means that we're supposed to try and auto-detect the number of
              # available CPU cores at run-time.
              NIX_BUILD_CORES="''${NIX_BUILD_CORES:-1}"
              if ((NIX_BUILD_CORES <= 0)); then
                guess=$(nproc 2>/dev/null || true)
                ((NIX_BUILD_CORES = guess <= 0 ? 1 : guess))
              fi
              export NIX_BUILD_CORES

              bash -eux $buildCommandPath
            '')
          ];
          passAsFile = [ "buildCommand" ];

          SHELL = "${bash}/bin/bash";
          PATH = lib.makeBinPath (
            (env.nativeBuildInputs or [ ])
            ++ [
              bash
              coreutils
            ]
          );
        }
        // (builtins.removeAttrs env [ "nativeBuildInputs" ])
      );

    passthru.tests.get-version =
      result:
      bootBash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/bash --version
        mkdir $out
      '';

    meta = with lib; {
      description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
      homepage = "https://www.gnu.org/software/bash";
      license = licenses.gpl3Plus;
      maintainers = teams.minimal-bootstrap.members;
      platforms = platforms.unix;
    };
  }
  ''
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
