{ stdenv, fetchurl, openssl, libtool, perl, libxml2 }:

let version = "9.9.3-P1"; in

stdenv.mkDerivation rec {

  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "0ddlvdxsyibm24v1wzbknywvalsrvl06gbvsrigpqc1vgkj25ahv";
  };

  patchPhase = ''
    sed -i 's/^\t.*run/\t/' Makefile.in
  '';

  buildInputs = [ openssl libtool perl libxml2 ];

  /* Why --with-libtool? */
  configureFlags = [ "--with-libtool" "--with-openssl=${openssl}"
    "--localstatedir=/var" ];

  meta = {
    homepage = "http://www.isc.org/software/bind";
    description = "ISC BIND: a domain name server";
    license = stdenv.lib.licenses.isc;

    maintainers = with stdenv.lib.maintainers; [viric simons];
    platforms = with stdenv.lib.platforms; linux;
  };
}
