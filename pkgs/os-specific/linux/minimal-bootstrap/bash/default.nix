{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bootBash
, gnumake
, gnused
, gnugrep
, gnutar
, gawk
, gzip
, gcc
, glibc
, binutils
, linux-headers
, derivationWithMeta
, bash
, coreutils
}:
let
  pname = "bash";
  version = "5.2.15";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "132qng0jy600mv1fs95ylnlisx2wavkkgpb19c6kmz7lnmjhjwhk";
  };
in
bootBash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gcc
    binutils
    gnumake
    gnused
    gnugrep
    gnutar
    gawk
    gzip
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

  meta = with lib; {
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
    homepage = "https://www.gnu.org/software/bash";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  tar xzf ${src}
  cd bash-${version}

  # Configure
  export CC="gcc -I${glibc}/include -I${linux-headers}/include"
  export LIBRARY_PATH="${glibc}/lib"
  export LIBS="-lc -lnss_files -lnss_dns -lresolv"
  export ac_cv_func_dlopen=no
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config} \
    --disable-nls \
    --disable-net-redirections

  # Build
  make SHELL=bash

  # Install
  make install
  ln -s bash $out/bin/sh
''
