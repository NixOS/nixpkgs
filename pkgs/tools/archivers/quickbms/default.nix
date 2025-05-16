{
  stdenv,
  lib,
  fetchzip,
  bzip2,
  lzo,
  openssl_1_1,
  opensslSupport ? false,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "0.12.0";
  pname = "quickbms";

  src = fetchzip {
    url = "https://aluigi.altervista.org/papers/quickbms-src-${version}.zip";
    hash = "sha256-thD4wYjiYuwCzjuXmhVfMEhhlSHHOLa5yl0uDhF6aMA=";
  };

  patches = [
    # Fix errors on x86_64 and _rotl definition
    ./0001-fix-compile.patch
  ] ++ lib.optional (!opensslSupport) ./0002-disable-openssl.patch;

  buildInputs = [
    bzip2
    lzo
    zlib
  ] ++ lib.optional opensslSupport openssl_1_1;

  env.NIX_CFLAGS_COMPILE = builtins.toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Universal script based file extractor and reimporter";
    homepage = "https://aluigi.altervista.org/quickbms.htm";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "quickbms";
  };
}
