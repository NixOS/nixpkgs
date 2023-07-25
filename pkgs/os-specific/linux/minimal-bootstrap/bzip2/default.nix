{ lib
, fetchurl
, bash
, tinycc
, gnumake
, gnupatch
, gzip
}:
let
  pname = "bzip2";
  version = "1.0.8";

  src = fetchurl {
    url = "https://sourceware.org/pub/bzip2/bzip2-${version}.tar.gz";
    sha256 = "0s92986cv0p692icqlw1j42y9nld8zd83qwhzbqd61p1dqbh6nmb";
  };

  patches = [
    # mes libc has no time support, so we remove that.
    # It also does not have fch{own,mod}, which we don't care about in the bootstrap
    # anyway, so we can null-op those calls.
    (fetchurl {
      url = "https://github.com/fosslinux/live-bootstrap/raw/87e9d7db9d22b400d1c05247254ac39ee2577e80/sysa/bzip2-1.0.8/patches/mes-libc.patch";
      sha256 = "14dciwib28h413skzfkh7samzh8x87dmwhldyxxphff04pvl1j3c";
    })
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    tinycc.compiler
    gnumake
    gnupatch
    gzip
  ];

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/bzip2 --version --help
      mkdir $out
    '';

  meta = with lib; {
    description = "High-quality data compression program";
    homepage = "https://www.sourceware.org/bzip2";
    license = licenses.bsdOriginal;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  cp ${src} bzip2.tar.gz
  gunzip bzip2.tar.gz
  untar --file bzip2.tar
  rm bzip2.tar
  cd bzip2-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}

  # Build
  make \
    CC="tcc -B ${tinycc.libs}/lib -I ." \
    AR="tcc -ar" \
    bzip2 bzip2recover

  # Install
  make install PREFIX=$out
''
