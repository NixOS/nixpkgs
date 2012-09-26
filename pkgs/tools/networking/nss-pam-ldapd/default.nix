{ stdenv, fetchurl, pkgconfig, openldap, python, pam, makeWrapper }:

stdenv.mkDerivation rec {
  name = "nss-pam-ldapd-${version}";
  version = "0.8.10";
  
  src = fetchurl {
    url = "http://arthurdejong.org/nss-pam-ldapd/${name}.tar.gz";
    sha256 = "673a5e235a40fd9aac74082bc64d2ac2280fc155fb00b21092650d2c963e79cc";
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
