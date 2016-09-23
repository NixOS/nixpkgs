{ stdenv, fetchurl, openssl, libtool, perl, libxml2 }:

let version = "9.10.4-P2"; in

stdenv.mkDerivation rec {
  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "08s48h5p916ixjiwgar4w6skc20crmg7yj1y7g89c083zvw8lnxk";
  };

  outputs = [ "bin" "lib" "dev" "out" "man" "dnsutils" "host" ];

  patches = [ ./dont-keep-configure-flags.patch ./remove-mkdir-var.patch ] ++
    stdenv.lib.optional stdenv.isDarwin ./darwin-openssl-linking-fix.patch;

  buildInputs = [ openssl libtool perl libxml2 ];

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
  ];

  postInstall = ''
    moveToOutput bin/bind9-config $dev
    moveToOutput bin/isc-config.sh $dev

    moveToOutput bin/host $host
    ln -sf $host/bin/host $bin/bin

    moveToOutput bin/dig $dnsutils
    moveToOutput bin/nslookup $dnsutils
    moveToOutput bin/nsupdate $dnsutils
    ln -sf $dnsutils/bin/{dig,nslookup,nsupdate} $bin/bin

    for f in $out/lib/*.la; do
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
