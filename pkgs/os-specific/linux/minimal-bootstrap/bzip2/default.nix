{
  lib,
  fetchurl,
  bash,
  tinycc,
  gnumake,
  gnutar,
  gzip,
}:
let
  pname = "bzip2";
  version = "1.0.8";

  src = fetchurl {
    url = "https://sourceware.org/pub/bzip2/bzip2-${version}.tar.gz";
    sha256 = "0s92986cv0p692icqlw1j42y9nld8zd83qwhzbqd61p1dqbh6nmb";
  };
in
bash.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnutar
      gzip
    ];

    passthru.tests.get-version =
      result:
      bash.runCommand "${pname}-get-version-${version}" { } ''
        ${result}/bin/bzip2 --help
        mkdir $out
      '';

    meta = with lib; {
      description = "High-quality data compression program";
      homepage = "https://www.sourceware.org/bzip2";
      license = licenses.bsdOriginal;
      teams = [ teams.minimal-bootstrap ];
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    tar xzf ${src}
    cd bzip2-${version}

    # Build
    make \
      -j $NIX_BUILD_CORES \
      CC="tcc -B ${tinycc.libs}/lib" \
      AR="tcc -ar" \
      bzip2 bzip2recover

    # Install
    make install -j $NIX_BUILD_CORES PREFIX=$out
  ''
