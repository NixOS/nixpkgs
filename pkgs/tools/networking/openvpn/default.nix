{ lib
, stdenv
, fetchurl
, pkg-config
, iproute2
, lzo
, openssl
, openssl_1_1
, pam
, useSystemd ? stdenv.isLinux
, systemd
, update-systemd-resolved
, util-linux
, pkcs11Support ? false
, pkcs11helper
}:

let
  inherit (lib) versionOlder optional optionals optionalString;

  generic = { version, sha256, extraBuildInputs ? [] }:
    let
      withIpRoute = stdenv.isLinux && (versionOlder version "2.5.4");
    in
    stdenv.mkDerivation
      rec {
        pname = "openvpn";
        inherit version;

        src = fetchurl {
          url = "https://swupdate.openvpn.net/community/releases/${pname}-${version}.tar.gz";
          inherit sha256;
        };

        nativeBuildInputs = [ pkg-config ];

        buildInputs = [ lzo ]
          ++ optional stdenv.isLinux pam
          ++ optional withIpRoute iproute2
          ++ optional useSystemd systemd
          ++ optional pkcs11Support pkcs11helper
          ++ extraBuildInputs;

        configureFlags = optionals withIpRoute [
          "--enable-iproute2"
          "IPROUTE=${iproute2}/sbin/ip"
        ]
        ++ optional useSystemd "--enable-systemd"
        ++ optional pkcs11Support "--enable-pkcs11"
        ++ optional stdenv.isDarwin "--disable-plugin-auth-pam";

        # We used to vendor the update-systemd-resolved script inside libexec,
        # but a separate package was made, that uses libexec/openvpn. Copy it
        # into libexec in case any consumers expect it to be there even though
        # they should use the update-systemd-resolved package instead.
        postInstall = ''
          mkdir -p $out/share/doc/openvpn/examples
          cp -r sample/sample-{config-files,keys,scripts}/ $out/share/doc/openvpn/examples
        '' + optionalString useSystemd ''
          install -Dm555 -t $out/libexec ${update-systemd-resolved}/libexec/openvpn/*
        '';

        enableParallelBuilding = true;

        meta = with lib; {
          description = "A robust and highly flexible tunneling application";
          downloadPage = "https://openvpn.net/community-downloads/";
          homepage = "https://openvpn.net/";
          license = licenses.gpl2Only;
          maintainers = with maintainers; [ viric peterhoeg ];
          platforms = platforms.unix;
        };
      };

in
{
  openvpn_24 = generic {
    version = "2.4.12";
    sha256 = "1vjx82nlkxrgzfiwvmmlnz8ids5m2fiqz7scy1smh3j9jnf2v5b6";
    extraBuildInputs = [ openssl_1_1 ];
  };

  openvpn = generic {
    version = "2.5.6";
    sha256 = "0gdd88rcan9vfiwkzsqn6fxxdim7kb1bsxrcra59c5xksprpwfik";
    extraBuildInputs = [ openssl ];
  };
}
