{ stdenv, fetchurl, openssl, libtool, perl, libxml2
, libseccomp ? null }:

let version = "9.10.4-P3"; in

stdenv.mkDerivation rec {
  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "1vxs29w4hnl7jcd7sknga58xv1qk2rcpsxyich7cpp7xi77faxd0";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  patches = [ ./dont-keep-configure-flags.patch ./remove-mkdir-var.patch ] ++
    stdenv.lib.optional stdenv.isDarwin ./darwin-openssl-linking-fix.patch;

  buildInputs = [ openssl libtool perl libxml2 ] ++
    stdenv.lib.optional stdenv.isLinux libseccomp;

  configureFlags = [
    "--localstatedir=/var"
    "--with-libtool"
    "--with-libxml2=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--without-atf"
    "--without-dlopen"
    "--without-docbook-xsl"
    "--without-gssapi"
    "--without-idn"
    "--without-idnlib"
    "--without-pkcs11"
    "--without-purify"
    "--without-python"
    "--enable-seccomp"
  ];

  postInstall = ''
    moveToOutput bin/bind9-config $dev
    moveToOutput bin/isc-config.sh $dev

    for f in "$out/lib/"*.la; do
      sed -i $f -e 's|-L${openssl.dev}|-L${openssl.out}|g'
    done
  '';

  meta = {
    homepage = "http://www.isc.org/software/bind";
    description = "Domain name server";
    license = stdenv.lib.licenses.isc;

    maintainers = with stdenv.lib.maintainers; [viric peti];
    platforms = with stdenv.lib.platforms; unix;
  };
}
