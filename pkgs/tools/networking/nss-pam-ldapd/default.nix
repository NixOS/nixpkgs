{ stdenv, fetchurl, pkgconfig, openldap, python, pam, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nss-pam-ldapd-${version}";
  version = "0.8.11";
  
  src = fetchurl {
    url = "http://arthurdejong.org/nss-pam-ldapd/${name}.tar.gz";
    sha256 = "9a841f6a46bf9f87213dc806c0f6507ac5016a2ee550d42c3ed9fb280c1e38e6";
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

  meta = {
    description = "LDAP identity and authentication for NSS/PAM";
    homepage = http://arthurdejong.org/nss-pam-ldapd/;
    license = [ "GPLv21" ];
  };
}
