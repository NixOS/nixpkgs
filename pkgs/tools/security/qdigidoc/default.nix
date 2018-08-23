{ stdenv, fetchgit, fetchurl, cmake, darkhttpd, gettext, makeWrapper, pkgconfig
, libdigidocpp, opensc, openldap, openssl, pcsclite, qtbase, qttranslations }:

stdenv.mkDerivation rec {
  name = "qdigidoc-${version}";
  version = "3.13.6";

  src = fetchgit {
    url = "https://github.com/open-eid/qdigidoc";
    rev = "v${version}";
    sha256 = "1qq9fgvkc7fi37ly3kgxksrm4m5rxk9k5s5cig8z0cszsfk6h9lx";
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

  patches = [
    # https://github.com/open-eid/qdigidoc/pull/163
    ./qt511.patch
  ];

  buildInputs = [
    libdigidocpp
    opensc
    openldap
    openssl
    pcsclite
    qtbase
    qttranslations
  ];

  postInstall = ''
    wrapProgram $out/bin/qdigidocclient \
      --prefix LD_LIBRARY_PATH : ${opensc}/lib/pkcs11/
  '';

  meta = with stdenv.lib; {
    description = "Qt-based UI for signing and verifying DigiDoc documents";
    homepage = https://www.id.ee/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
