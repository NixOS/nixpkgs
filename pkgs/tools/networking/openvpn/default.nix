{ lib
, stdenv
, fetchurl
, pkg-config
, libcap_ng
, libnl
, lz4
, lzo
, openssl
, pam
, useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, update-systemd-resolved
, pkcs11Support ? false
, pkcs11helper
, nixosTests
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openvpn";
  version = "2.6.10";

  src = fetchurl {
    url = "https://swupdate.openvpn.net/community/releases/openvpn-${finalAttrs.version}.tar.gz";
    hash = "sha256-GZO7t7nttDBibqokVz+IH9PfZC9Cf8uCSxrtH8obzJs=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lz4 lzo openssl ]
    ++ optionals stdenv.isLinux [ libcap_ng libnl pam ]
    ++ optional useSystemd systemd
    ++ optional pkcs11Support pkcs11helper;

  configureFlags = optional useSystemd "--enable-systemd"
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

  passthru.tests = {
    inherit (nixosTests) initrd-network-openvpn systemd-initrd-networkd-openvpn;
  };

  meta = with lib; {
    description = "A robust and highly flexible tunneling application";
    downloadPage = "https://openvpn.net/community-downloads/";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ viric peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "openvpn";
  };
})
