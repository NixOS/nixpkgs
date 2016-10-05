{ stdenv, fetchurl, iproute, lzo, openssl, pam, systemd, pkgconfig
, pkcs11Support ? false, pkcs11helper ? null,
}:

assert pkcs11Support -> (pkcs11helper != null);

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openvpn-2.3.12";

  src = fetchurl {
    url = "http://swupdate.openvpn.net/community/releases/${name}.tar.gz";
    sha256 = "1zqwq19xg6yf90nv35yr8r0ljas5f42v4n9hjjmhlnzpan69plzm";
  };

  patches = optional stdenv.isLinux ./systemd-notify.patch;

  buildInputs = [ lzo openssl pkgconfig ]
                  ++ optionals stdenv.isLinux [ pam systemd iproute ]
                  ++ optional pkcs11Support pkcs11helper;

  configureFlags = optionals stdenv.isLinux [
    "--enable-systemd"
    "--enable-iproute2"
    "IPROUTE=${iproute}/sbin/ip" ]
    ++ optional pkcs11Support "--enable-pkcs11";

  postInstall = ''
    mkdir -p $out/share/doc/openvpn/examples
    cp -r sample/sample-config-files/ $out/share/doc/openvpn/examples
    cp -r sample/sample-keys/ $out/share/doc/openvpn/examples
    cp -r sample/sample-scripts/ $out/share/doc/openvpn/examples
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A robust and highly flexible tunneling application";
    homepage = http://openvpn.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
