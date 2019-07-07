{ stdenv, fetchurl
, pkgconfig, makeWrapper, autoreconfHook
, openldap, python, pam
}:

stdenv.mkDerivation rec {
  name = "nss-pam-ldapd-${version}";
  version = "0.9.10";

  src = fetchurl {
    url = "https://arthurdejong.org/nss-pam-ldapd/${name}.tar.gz";
    sha256 = "1cqamcr6qpgwxijlr6kg7jspjamjra8w0haan0qssn0yxn95d7c0";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper autoreconfHook ];
  buildInputs = [ openldap pam python ];

  preConfigure = ''
    substituteInPlace Makefile.in --replace "install-data-local: " "# install-data-local: "
  '';

  configureFlags = [
    "--with-bindpw-file=/run/nslcd/bindpw"
    "--with-nslcd-socket=/run/nslcd/socket"
    "--with-nslcd-pidfile=/run/nslcd/nslcd.pid"
    "--with-pam-seclib-dir=$(out)/lib/security"
    "--enable-kerberos=no"
  ];

  postInstall = ''
    wrapProgram $out/sbin/nslcd --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  meta = with stdenv.lib; {
    description = "LDAP identity and authentication for NSS/PAM";
    homepage = https://arthurdejong.org/nss-pam-ldapd/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
