{ stdenv, fetchurl, openssl, expat, libevent, swig, pythonPackages }:

let
  inherit (pythonPackages) python;
in stdenv.mkDerivation rec {
  pname = "pyunbound";
  name = "${pname}-${version}";
  version = "1.7.3";

  src = fetchurl {
    url = "http://unbound.net/downloads/unbound-${version}.tar.gz";
    sha256 = "0bb0p8nbda77ghx20yfl7hqxm9x709223q35465v99i8v4ay27f1";
  };

  buildInputs = [ openssl expat libevent swig python ];

  patchPhase = ''substituteInPlace Makefile.in \
    --replace "\$(DESTDIR)\$(PYTHON_SITE_PKG)" "$out/${python.sitePackages}" \
    --replace "\$(LIBTOOL) --mode=install cp _unbound.la" "cp _unbound.la"
    '';

  preConfigure = "export PYTHON_VERSION=${python.pythonVersion}";

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-libexpat=${expat.dev}"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--sbindir=\${out}/bin"
    "--enable-pie"
    "--enable-relro-now"
    "--with-pyunbound"
    "DESTDIR=$out PREFIX="
  ];

  preInstall = ''
    mkdir -p $out/${python.sitePackages} $out/etc/${pname}
    cp .libs/_unbound.so .libs/libunbound.so* $out/${python.sitePackages}
    substituteInPlace _unbound.la \
      --replace "-L.libs $PWD/libunbound.la" "-L$out/${python.sitePackages}" \
      --replace "libdir=\'$PWD/${python.sitePackages}\'" "libdir=\'$out/${python.sitePackages}\'"
    '';

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf pyunbound-install lib" ];

  # All we want is the Unbound Python module
  postInstall = ''
    # Generate the built in root anchor and root key and store these in a logical place
    # to be used by tools depending only on the Python module
    $out/bin/unbound-anchor -l | head -1 > $out/etc/${pname}/root.anchor
    $out/bin/unbound-anchor -l | tail --lines=+2 - > $out/etc/${pname}/root.key
    # We don't need anything else
    rm -fR $out/bin $out/share $out/include $out/etc/unbound
    patchelf --replace-needed libunbound.so.2 $out/${python.sitePackages}/libunbound.so.2 $out/${python.sitePackages}/_unbound.so
    '';

  meta = with stdenv.lib; {
    description = "Python library for Unbound, the validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = http://www.unbound.net;
    maintainers = with maintainers; [ leenaars ];
    platforms = stdenv.lib.platforms.unix;
  };
}
