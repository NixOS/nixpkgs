{ stdenv, mkDerivation, fetchgit, fetchurl, cmake, darkhttpd, gettext, makeWrapper, pkgconfig
, libdigidocpp, opensc, openldap, openssl, pcsclite, qtbase, qttranslations, qtsvg }:

mkDerivation rec {
  pname = "qdigidoc";
  version = "4.2.3";

  src = fetchgit {
    url = "https://github.com/open-eid/DigiDoc4-Client";
    rev = "v${version}";
    sha256 = "1hj49vvg8vrayr9kpz73fafa7k298hmiamkyd8c3ipy6s51xh6q4";
    fetchSubmodules = true;
  };

  tsl = fetchurl {
    url = "https://ec.europa.eu/information_society/policy/esignature/trusted-list/tl-mp.xml";
    sha256 = "0llr2fj8vd097hcr1d0xmzdy4jydv0b5j5qlksbjffs22rqgal14";
  };

  nativeBuildInputs = [ cmake darkhttpd gettext makeWrapper pkgconfig ];

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

  meta = with stdenv.lib; {
    description = "Qt-based UI for signing and verifying DigiDoc documents";
    homepage = "https://www.id.ee/";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko mmahut ];
  };
}
