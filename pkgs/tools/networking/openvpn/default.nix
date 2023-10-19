{ lib
, stdenv
, fetchurl
, pkg-config
, iproute2
, lzo
, openssl
, pam
, useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, update-systemd-resolved
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
  openvpn = generic {
    version = "2.5.8";
    sha256 = "1cixqm4gn2d1v8qkbww75j30fzvxz13gc7whcmz54i0x4fvibwx6";
    extraBuildInputs = [ openssl ];
  };
}
