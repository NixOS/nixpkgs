{
  stdenv,
  lib,
  fetchzip,
  fetchpatch,
  bzip2,
  lzo,
  openssl_1_1,
  opensslSupport ? false,
  zlib,
}:

stdenv.mkDerivation rec {
  version = "0.11.0";
  pname = "quickbms";

  src = fetchzip {
    url = "https://aluigi.altervista.org/papers/quickbms-src-${version}.zip";
    hash = "sha256-uQKTE36pLO8uhrX794utqaDGUeyqRz6zLCQFA7DYkNc=";
  };

  patches = [
    # Fix errors on x86_64 and _rotl definition
    (fetchpatch {
      name = "0001-fix-compile.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-compile.patch?h=quickbms&id=a2e3e4638295d7cfe39513bfef9447fb23154a6b";
      hash = "sha256-49fT/L4BNzMYnq1SXhFMgSDLybLkz6KSbgKmUpZZu08=";
      stripLen = 1;
    })
  ] ++ lib.optional (!opensslSupport) ./0002-disable-openssl.patch;

  buildInputs = [
    bzip2
    lzo
    zlib
  ] ++ lib.optional (opensslSupport) openssl_1_1;

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
