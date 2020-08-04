{ stdenv, fetchurl, fetchpatch, pkgconfig, makeWrapper
, iproute, lzo, openssl, pam
, useSystemd ? stdenv.isLinux, systemd ? null, utillinux ? null
, pkcs11Support ? false, pkcs11helper ? null,
}:

assert useSystemd -> (systemd != null);
assert pkcs11Support -> (pkcs11helper != null);

with stdenv.lib;

let
  # Check if the script needs to have other binaries wrapped when changing this.
  update-resolved = fetchurl {
    url = "https://raw.githubusercontent.com/jonathanio/update-systemd-resolved/v1.3.0/update-systemd-resolved";
    sha256 = "021qzv1k0zxgv1rmyfpqj3zlzqr28xa7zff1n7vrbjk36ijylpsc";
  };

in stdenv.mkDerivation rec {
  pname = "openvpn";
  version = "2.4.9";

  src = fetchurl {
    url = "https://swupdate.openvpn.net/community/releases/${pname}-${version}.tar.xz";
    sha256 = "1qpbllwlha7cffsd5dlddb8rl22g9rar5zflkz1wrcllhvfkl7v4";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];

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
  '' + optionalString useSystemd ''
    install -Dm555 ${update-resolved} $out/libexec/update-systemd-resolved
    wrapProgram $out/libexec/update-systemd-resolved \
      --prefix PATH : ${makeBinPath [ stdenv.shell iproute systemd utillinux ]}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A robust and highly flexible tunneling application";
    downloadPage = "https://openvpn.net/community-downloads/";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.unix;
    updateWalker = true;
  };
}
