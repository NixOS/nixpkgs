{ stdenv, fetchurl, openssl, libtool, perl, libxml2 }:

let version = "9.10.2-P4"; in

stdenv.mkDerivation rec {
  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "1f4w89qmsgql88nbykz82p2nwbf5m889vzlfy9bjj8gg3pn222y0";
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
    description = "Domain name server";
    license = stdenv.lib.licenses.isc;

    maintainers = with stdenv.lib.maintainers; [viric simons];
    platforms = with stdenv.lib.platforms; unix;
  };
}
