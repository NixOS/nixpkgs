{
  autoreconfHook,
  bash,
  coreutils,
  docbook_xml_dtd_45,
  docbook_xsl,
  docbook-xsl-nons,
  fetchgit,
  findutils,
  flex,
  getopt,
  gnugrep,
  gnused,
  lib,
  libxml2,
  libxslt,
  makeWrapper,
  stdenv,
  testers,
  w3m,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlto";
  version = "0.0.29";

  src = fetchgit {
    url = "https://pagure.io/xmlto.git";
    rev = finalAttrs.version;
    hash = "sha256-wttag8J1t9cBPBHNY7me2H0IPOzS8IjfCLIHNWq67Do=";
  };

  postPatch = ''
    patchShebangs xmlif/test/run-test

    substituteInPlace "xmlto.in" \
      --replace-fail "@XMLTO_BASH_PATH@" "${bash}/bin/bash" \
      --replace-fail "@FIND@" "${findutils}/bin/find" \
      --replace-fail "@GETOPT@" "${getopt}/bin/getopt" \
      --replace-fail "@GREP@" "${gnugrep}/bin/grep" \
      --replace-fail "@MKTEMP@" "$(type -P mktemp)" \
      --replace-fail "@SED@" "${gnused}/bin/sed" \
      --replace-fail "@TAIL@" "${coreutils}/bin/tail"

    for f in format/docbook/* xmlto.in; do
      substituteInPlace $f \
        --replace-fail "http://docbook.sourceforge.net/release/xsl/current" "${docbook-xsl-nons}/xml/xsl/docbook"
    done
  '';

  # `libxml2' provides `xmllint', needed at build-time and run-time.
  # `libxslt' provides `xsltproc', used by `xmlto' at run-time.
  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    flex
    getopt
  ];

  buildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt
  ];

  postInstall = ''
    # `w3m' is needed for HTML to text conversions.
    wrapProgram "$out/bin/xmlto" \
       --prefix PATH : "${lib.makeBinPath [ libxslt libxml2 getopt w3m ]}"
  '';

  passthru.tests.version = testers.testVersion {
    command = "${lib.getExe finalAttrs.finalPackage} --version";
    package = finalAttrs.finalPackage;
  };

  meta = {
    changelog = "https://pagure.io/xmlto/blob/master/f/ChangeLog";
    description = "Front-end to an XSL toolchain";
    homepage = "https://pagure.io/xmlto/";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      xmlto is a front-end to an XSL toolchain.  It chooses an
      appropriate stylesheet for the conversion you want and applies
      it using an external XSL-T processor.  It also performs any
      necessary post-processing.
    '';
    mainProgram = "xmlto";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
