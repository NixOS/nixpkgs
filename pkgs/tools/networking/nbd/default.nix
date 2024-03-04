{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, pkg-config
, glib
, which
, bison
, flex
, opensp
, docbook2x
, docbook_sgml_dtd_41
, docbook_sgml_dtd_45
, nixosTests
, libnl
, linuxHeaders
, gnutls
}:

stdenv.mkDerivation rec {
  pname = "nbd";
  version = "3.26.1";

  src = fetchFromGitHub {
    owner = "NetworkBlockDevice";
    repo = "nbd";
    rev = "refs/tags/nbd-${version}";
    hash = "sha256-dFc96AL30kN9epJQbfEqJ6MM+qVFvwy721w3jy3mbTw=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "m4_esyscmd(support/genver.sh | tr -d '\n')" "$version"
    substituteInPlace man/Makefile.am \
      --replace-fail "docbook2man" "docbook2man --sgml"
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    bison
    flex
    docbook2x # docbook2man
  ];

  buildInputs = [
    glib
    gnutls
  ] ++ lib.optionals stdenv.isLinux [
    libnl
    linuxHeaders
  ];

  configureFlags = [
    "--sysconfdir=/etc"
  ];

  env = {
    # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";
    SGML_CATALOG_FILES = lib.concatStringsSep ":" [
      "${docbook_sgml_dtd_41}/sgml/dtd/docbook-4.1/docbook.cat"
      "${docbook_sgml_dtd_45}/sgml/dtd/docbook-4.5/docbook.cat"
    ];
  };

  doCheck = !stdenv.isDarwin;

  passthru.tests = {
    test = nixosTests.nbd;
  };

  meta = {
    homepage = "https://nbd.sourceforge.io/";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
