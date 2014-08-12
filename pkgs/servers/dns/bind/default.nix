{ stdenv, fetchurl, openssl, libtool, perl, libxml2 }:

let version = "9.9.5-W1"; in

stdenv.mkDerivation rec {

  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "1b3ycb376b1j2fc0k6w16k8j9vgsfrzy3nlw1vxzzi41fgyqmcd3";
  };

  patchPhase = ''
    sed -i 's/^\t.*run/\t/' Makefile.in
  '';

  buildInputs = [ openssl libtool perl libxml2 ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-libtool"
    "--with-libxml2=${libxml2}"
    "--with-openssl=${openssl}"
    "--without-atf"
    "--without-dlopen"
    "--without-docbook-xsl"
    "--without-gssapi"
    "--without-idn"
    "--without-idnlib"
    "--without-pkcs11"
    "--without-purify"
    "--without-python"
  ];

  meta = {
    homepage = "http://www.isc.org/software/bind";
    description = "ISC BIND: a domain name server";
    license = stdenv.lib.licenses.isc;

    maintainers = with stdenv.lib.maintainers; [viric simons];
    platforms = with stdenv.lib.platforms; unix;
  };
}
