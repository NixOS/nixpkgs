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
  version = "5.4.3";

  src = fetchurl {
    url = "https://tukaani.org/xz/xz-${version}.tar.gz";
    hash = "sha256-HDguC8Lk4K9YOYqQPdYv/35RAXHS3keh6+BtFSjpt+k=";
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

    meta = with lib; {
      description = "A general-purpose data compression software, successor of LZMA";
      homepage = "https://tukaani.org/xz";
      license = with licenses; [
        gpl2Plus
        lgpl21Plus
      ];
      maintainers = teams.minimal-bootstrap.members;
      platforms = platforms.unix;
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
    bash ./configure \
      --prefix=$out \
      --build=${buildPlatform.config} \
      --host=${hostPlatform.config} \
      --disable-shared \
      --disable-assembler

    # Build
    make -j $NIX_BUILD_CORES

    # Install
    make -j $NIX_BUILD_CORES install
  ''
