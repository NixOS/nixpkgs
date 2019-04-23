{ stdenv, fetchurl, iproute, lzo, openssl, pam, pkgconfig
, useSystemd ? stdenv.isLinux, systemd ? null
, pkcs11Support ? false, pkcs11helper ? null,
}:

assert useSystemd -> (systemd != null);
assert pkcs11Support -> (pkcs11helper != null);

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openvpn-${version}";
  version = "2.4.7";

  src = fetchurl {
    url = "https://swupdate.openvpn.net/community/releases/${name}.tar.xz";
    sha256 = "0j7na936isk9j8nsdrrbw7wmy09inmjqvsb8mw8az7k61xbm6bx4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lzo openssl ]
                  ++ optionals stdenv.isLinux [ pam iproute ]
                  ++ optional useSystemd systemd
                  ++ optional pkcs11Support pkcs11helper;

  configureFlags = optionals stdenv.isLinux [
    "--enable-iproute2"
    "IPROUTE=${iproute}/sbin/ip" ]
    ++ optional useSystemd "--enable-systemd"
    ++ optional pkcs11Support "--enable-pkcs11"
    ++ optional stdenv.isDarwin "--disable-plugin-auth-pam";

  postInstall = ''
    mkdir -p $out/share/doc/openvpn/examples
    cp -r sample/sample-config-files/ $out/share/doc/openvpn/examples
    cp -r sample/sample-keys/ $out/share/doc/openvpn/examples
    cp -r sample/sample-scripts/ $out/share/doc/openvpn/examples
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A robust and highly flexible tunneling application";
    homepage = https://openvpn.net/;
    downloadPage = "https://openvpn.net/index.php/open-source/downloads.html";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.unix;
    updateWalker = true;
  };
}
