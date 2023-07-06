{ fetchurl, fetchpatch, lib, stdenv, libxml2, libxslt
, docbook_xml_dtd_45, docbook_xsl, flex, w3m
, bash, getopt, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xmlto";
  version = "0.0.28";
  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0xhj8b2pwp4vhl9y16v3dpxpsakkflfamr191mprzsspg4xdyc0i";
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
      --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace "xmlto.in" \
      --replace "/usr/bin/locale" "$(type -P locale)"
    substituteInPlace "xmlto.in" \
      --replace "mktemp" "$(type -P mktemp)"
  '';

  # `libxml2' provides `xmllint', needed at build-time and run-time.
  # `libxslt' provides `xsltproc', used by `xmlto' at run-time.
  nativeBuildInputs = [ makeWrapper flex getopt ];
  buildInputs = [ libxml2 libxslt docbook_xml_dtd_45 docbook_xsl ];

  postInstall = ''
    # `w3m' is needed for HTML to text conversions.
    wrapProgram "$out/bin/xmlto" \
       --prefix PATH : "${lib.makeBinPath [ libxslt libxml2 getopt w3m ]}"
  '';

  meta = {
    description = "Front-end to an XSL toolchain";

    longDescription = ''
      xmlto is a front-end to an XSL toolchain.  It chooses an
      appropriate stylesheet for the conversion you want and applies
      it using an external XSL-T processor.  It also performs any
      necessary post-processing.
    '';

    license = lib.licenses.gpl2Plus;
    homepage = "https://pagure.io/xmlto/";
    platforms = lib.platforms.unix;
  };
}
