{ lib, stdenv
, fetchurl
, pkg-config
, makeWrapper
, runtimeShell
, iproute2
, lzo
, openssl
, pam
, useSystemd ? stdenv.isLinux
, systemd
, util-linux
, pkcs11Support ? false
, pkcs11helper
}:

with lib;
let
  # Check if the script needs to have other binaries wrapped when changing this.
  update-resolved = fetchurl {
    url = "https://raw.githubusercontent.com/jonathanio/update-systemd-resolved/v1.3.0/update-systemd-resolved";
    sha256 = "021qzv1k0zxgv1rmyfpqj3zlzqr28xa7zff1n7vrbjk36ijylpsc";
  };

  generic = { version, sha256 }:
    let
      withIpRoute = stdenv.isLinux && (versionOlder version "2.5.4");
    in
    stdenv.mkDerivation
      rec {
        pname = "openvpn";
        inherit version;

        src = fetchurl {
          url = "https://swupdate.openvpn.net/community/releases/${pname}-${version}.tar.xz";
          inherit sha256;
        };

        nativeBuildInputs = [ makeWrapper pkg-config ];

        buildInputs = [ lzo openssl ]
          ++ optional stdenv.isLinux pam
          ++ optional withIpRoute iproute2
          ++ optional useSystemd systemd
          ++ optional pkcs11Support pkcs11helper;

        configureFlags = optionals withIpRoute [
          "--enable-iproute2"
          "IPROUTE=${iproute2}/sbin/ip"
        ]
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
            --prefix PATH : ${makeBinPath [ runtimeShell iproute2 systemd util-linux ]}
        '';

        enableParallelBuilding = true;

        meta = with lib; {
          description = "A robust and highly flexible tunneling application";
          downloadPage = "https://openvpn.net/community-downloads/";
          homepage = "https://openvpn.net/";
          license = licenses.gpl2;
          maintainers = with maintainers; [ viric peterhoeg ];
          platforms = platforms.unix;
        };
      };

in
{
  openvpn_24 = generic {
    version = "2.4.11";
    sha256 = "06s4m0xvixjhd3azrzbsf4j86kah4xwr2jp6cmcpc7db33rfyyg5";
  };

  openvpn = generic {
    version = "2.5.5";
    sha256 = "sha256-EZvWn6AhCDj2zaonNpbcc476IA9FTb4R6237dd+2ADs=";
  };
}
