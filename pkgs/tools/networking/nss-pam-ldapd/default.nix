{ stdenv, fetchurl
, pkgconfig, makeWrapper, autoreconfHook
, openldap, python, pam
}:

stdenv.mkDerivation rec {
  pname = "nss-pam-ldapd";
  version = "0.9.11";

  src = fetchurl {
    url = "https://arthurdejong.org/nss-pam-ldapd/${pname}-${version}.tar.gz";
    sha256 = "1dna3r0q6sjhhlkhcp8x2zkslrd4y7701kk6fl5r940sdph1pmyh";
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
    homepage = "https://arthurdejong.org/nss-pam-ldapd/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
