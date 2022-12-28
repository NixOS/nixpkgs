{ lib
, mkDerivation
, fetchurl
, cmake
, gettext
, pkg-config
, libdigidocpp
, opensc
, openldap
, openssl
, pcsclite
, qtbase
, qttranslations
, qtsvg
}:

mkDerivation rec {
  pname = "qdigidoc";
  version = "4.2.12";

  src = fetchurl {
    url =
      "https://github.com/open-eid/DigiDoc4-Client/releases/download/v${version}/qdigidoc4-${version}.tar.gz";
    hash = "sha256-6bso1qvhVhbBfrcTq4S+aHtHli7X2A926N4r45ztq4E=";
  };

  tsl = fetchurl {
    url = "https://ec.europa.eu/tools/lotl/eu-lotl-pivot-300.xml";
    sha256 = "1cikz36w9phgczcqnwk4k3mx3kk919wy2327jksmfa4cjfjq4a8d";
  };

  nativeBuildInputs = [ cmake gettext pkg-config ];

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

  # qdigidoc4's `QPKCS11::reload()` dlopen()s "opensc-pkcs11.so" in QLibrary,
  # i.e. OpenSC's module is searched for in libQt5Core's DT_RUNPATH and fixing
  # qdigidoc4's DT_RUNPATH has no effect on Linux (at least OpenBSD's ld.so(1)
  # searches the program's runtime path as well).
  # LD_LIBRARY_PATH takes precedence for all calling objects, see dlopen(3).
  # https://github.com/open-eid/cmake/pull/35 might be an alternative.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/"
  ];

  meta = with lib; {
    description = "Qt-based UI for signing and verifying DigiDoc documents";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmahut yana ];
  };
}
