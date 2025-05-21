{
  mkDerivation,
  libutil,
  libpam,
  libbsm,
  cap_mkdb,
}:
mkDerivation {
  path = "usr.bin/login";
  buildInputs = [
    libutil
    libpam
    libbsm
  ];
  extraNativeBuildInputs = [ cap_mkdb ];

  postPatch = ''
    sed -E -i -e "s|..DESTDIR./etc|\''${CONFDIR}|g" $BSDSRCDIR/usr.bin/login/Makefile
  '';

  MK_TESTS = "no";
  MK_SETUID_LOGIN = "no";

  postInstall = ''
    mkdir -p $out/etc
    make $makeFlags installconfig
  '';
}
