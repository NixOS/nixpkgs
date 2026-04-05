{
  lib,
  buildPlatform,
  hostPlatform,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnused,
  gnugrep,
  gawk,
  gnutar,
  gzip,
}:
let
  pname = "xz";

  # At least versions 5.6.4 and 5.8.2 crash with spurious OoM when decompressing
  # certain tarballs, when compiled with tcc.
  version = "5.4.7";

  src = fetchurl {
    url = "https://tukaani.org/xz/xz-${version}.tar.gz";
    hash = "sha256-jbZmTEjKB5CLkrrtz+fzuiP0nvJHaGRRirXbZyODbnE=";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnused
      gnugrep
      gawk
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/xz --version
        mkdir $out
      '';

    meta = {
      description = "General-purpose data compression software, successor of LZMA";
      homepage = "https://tukaani.org/xz";
      license = with lib.licenses; [
        gpl2Plus
        lgpl21Plus
      ];
      teams = [ lib.teams.minimal-bootstrap ];
      platforms = lib.platforms.unix;
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    cd xz-${version}

    # Configure
    export CC="tcc -B ${tinycc.libs}/lib"
    export AR="tcc -ar"
    export LD=tcc
    # With a lower max_cmd_len (which is mistakenly detected by the
    # configure script), libtool invokes ar in append mode. This is not
    # supported by tinycc.
    export lt_cv_sys_max_cmd_len=32768
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-shared \
      --disable-assembler \
      --disable-dependency-tracking

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
