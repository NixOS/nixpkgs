{ stdenv, fetchgit, cmake, gettext, makeWrapper, pkgconfig, libdigidocpp
, opensc, openldap, openssl, pcsclite, qtbase, qttranslations }:

stdenv.mkDerivation rec {
  name = "qdigidoc-${version}";
  version = "3.13.6";

  src = fetchgit {
    url = "https://github.com/open-eid/qdigidoc";
    rev = "v${version}";
    sha256 = "1qq9fgvkc7fi37ly3kgxksrm4m5rxk9k5s5cig8z0cszsfk6h9lx";
    fetchSubmodules = true;
  };

  patches = [
    # https://github.com/open-eid/qdigidoc/pull/163
    ./qt511.patch
  ];

  nativeBuildInputs = [ cmake gettext makeWrapper pkgconfig ];

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
