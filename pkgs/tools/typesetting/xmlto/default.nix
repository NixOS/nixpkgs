{
  bash,
  coreutils,
  docbook_xml_dtd_45,
  docbook_xsl,
  docbook-xsl-ns,
  fetchpatch,
  fetchurl,
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
  version = "0.0.28";

  src = fetchurl {
    url = "https://releases.pagure.org/xmlto/xmlto-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ETDfOnlX659vDSnkqhx1cyp9+21jm+AThZtcfsVCEnY=";
  };

  # Note: These patches modify `xmlif/xmlif.l`, which requires `flex` to be rerun.
  patches = [
    # Fixes implicit `int` on `main`, which is an error with clang 16.
    (fetchpatch {
      url = "https://pagure.io/xmlto/c/8e34f087bf410bcc5fe445933d6ad9bae54f24b5.patch";
      hash = "sha256-z5riDBZBVuFeBcjI++dAl3nTIgOPau4Gag0MJbYt+cc=";
    })
    # Fixes implicit `int` on `ifsense`, which is also an error with clang 16.
    (fetchpatch {
      url = "https://pagure.io/xmlto/c/1375e2df75530cd198bd16ac3de38e2b0d126276.patch";
      hash = "sha256-fM6ZdTigrcC9cbXiKu6oa5Hs71mrREockB1wRlw6nDk=";
    })
  ];

  postPatch = ''
    patchShebangs xmlif/test/run-test

    substituteInPlace "xmlto.in" \
      --replace-fail "@BASH@" "${bash}/bin/bash" \
      --replace-fail "@FIND@" "${findutils}/bin/find" \
      --replace-fail "@GETOPT@" "${getopt}/bin/getopt" \
      --replace-fail "@GREP@" "${gnugrep}/bin/grep" \
      --replace-fail "@MKTEMP@" "$(type -P mktemp)" \
      --replace-fail "@SED@" "${gnused}/bin/sed" \
      --replace-fail "@TAIL@" "${coreutils}/bin/tail"

    for f in format/docbook/* xmlto.in; do
      substituteInPlace $f \
        --replace-fail "http://docbook.sourceforge.net/release/xsl/current" "${docbook-xsl-ns}/xml/xsl/docbook"
    done
  '';

  # `libxml2' provides `xmllint', needed at build-time and run-time.
  # `libxslt' provides `xsltproc', used by `xmlto' at run-time.
  nativeBuildInputs = [
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
