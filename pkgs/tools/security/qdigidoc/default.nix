{ lib, mkDerivation, fetchurl, cmake, darkhttpd, gettext, makeWrapper
, pkg-config, libdigidocpp, opensc, openldap, openssl, pcsclite, qtbase
, qttranslations, qtsvg }:

mkDerivation rec {
  pname = "qdigidoc";
  version = "4.2.9";

  src = fetchurl {
    url =
      "https://github.com/open-eid/DigiDoc4-Client/releases/download/v${version}/qdigidoc4-${version}.tar.gz";
    sha256 = "1rhd3mvj6ld16zgfscj81f1vhs2nvifsizky509l1av7dsjfbbzr";
  };

  tsl = fetchurl {
    url = "https://ec.europa.eu/tools/lotl/eu-lotl-pivot-300.xml";
    sha256 = "1cikz36w9phgczcqnwk4k3mx3kk919wy2327jksmfa4cjfjq4a8d";
  };

  nativeBuildInputs = [ cmake darkhttpd gettext makeWrapper pkg-config ];

  postPatch = ''
    substituteInPlace client/CMakeLists.txt \
      --replace $\{TSL_URL} file://${tsl}
  '';

  buildInputs = [
    libdigidocpp
    opensc
    openldap
    openssl
    pcsclite
    qtbase
    qtsvg
    qttranslations
  ];

  postInstall = ''
    wrapProgram $out/bin/qdigidoc4 \
      --prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/
  '';

  meta = with lib; {
    description = "Qt-based UI for signing and verifying DigiDoc documents";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko mmahut ];
  };
}
