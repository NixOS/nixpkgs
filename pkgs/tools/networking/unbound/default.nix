{ stdenv, fetchurl, openssl, expat, libevent }:

stdenv.mkDerivation rec {
  name = "unbound-${version}";
  version = "1.5.3";

  src = fetchurl {
    url = "http://unbound.net/downloads/${name}.tar.gz";
    sha256 = "1jly2apag4yg649w3flaq73wdrcfyxnhx5py9j73y7adxmswigbn";
  };

  outputs = [ "out" "lib" "man" ]; # "dev" would only split ~20 kB

  buildInputs = [ openssl expat libevent ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-libexpat=${expat}"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf" ];

  # get rid of runtime dependencies on $dev outputs
  postInstall = ''
    substituteInPlace "$lib/lib/libunbound.la" \
      --replace '-L${openssl.dev}/lib' "" \
      --replace '-L${libevent.dev}/lib' ""
  '';

  meta = with stdenv.lib; {
    description = "Validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = [ maintainers.emery ];
    platforms = platforms.unix;
  };
}
