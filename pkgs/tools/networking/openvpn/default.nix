{ stdenv, fetchurl, pkgconfig
, iproute, lzo, openssl, pam
, useSystemd ? stdenv.isLinux, systemd ? null, utillinux ? null
, pkcs11Support ? false, pkcs11helper ? null,
}:

assert useSystemd -> (systemd != null);
assert pkcs11Support -> (pkcs11helper != null);

with stdenv.lib;

let
  # There is some fairly brittle string substitutions going on to replace paths,
  # so please verify this script in case you are upgrading it
  update-resolved = fetchurl {
    url = "https://raw.githubusercontent.com/jonathanio/update-systemd-resolved/v1.2.7/update-systemd-resolved";
    sha256 = "12zfzh42apwbj7ks5kfxf3far7kaghlby4yapbhn00q8pbdlw7pq";
  };

in stdenv.mkDerivation rec {
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

    ${optionalString useSystemd ''
      install -Dm755 ${update-resolved} $out/libexec/update-systemd-resolved

      substituteInPlace $out/libexec/update-systemd-resolved \
        --replace '/usr/bin/env bash' '${stdenv.shell} -e' \
        --replace 'busctl call'       '${getBin systemd}/bin/busctl call' \
        --replace '(ip '              '(${getBin iproute}/bin/ip ' \
        --replace 'logger '           '${getBin utillinux}/bin/logger '
    ''}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A robust and highly flexible tunneling application";
    downloadPage = "https://openvpn.net/index.php/open-source/downloads.html";
    homepage = https://openvpn.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
    updateWalker = true;
  };
}
