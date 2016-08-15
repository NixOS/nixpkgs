{ stdenv, fetchurl, pkgconfig, openldap, python, pam, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nss-pam-ldapd-${version}";
  version = "0.8.13";
  
  src = fetchurl {
    url = "http://arthurdejong.org/nss-pam-ldapd/${name}.tar.gz";
    sha256 = "08jxxskzv983grc28zksk9fd8q5qad64rma9vcjsq0l4r6cax4mp";
  };
  
  buildInputs = [ makeWrapper pkgconfig python openldap pam ];

  preConfigure = ''
    substituteInPlace Makefile.in --replace "install-data-local: " "# install-data-local: "
  '';

  configureFlags = [
    "--with-bindpw-file=/run/nslcd/bindpw"
    "--with-nslcd-socket=/run/nslcd/socket"
    "--with-nslcd-pidfile=/run/nslcd/nslcd.pid"
    "--with-pam-seclib-dir=$(out)/lib/security"
  ];

  postInstall = ''
    wrapProgram $out/sbin/nslcd --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  meta = with stdenv.lib; {
    description = "LDAP identity and authentication for NSS/PAM";
    homepage = http://arthurdejong.org/nss-pam-ldapd/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
