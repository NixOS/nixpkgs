{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libcap_ng,
  libnl,
  lz4,
  lzo,
  openssl,
  pam,
  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  update-systemd-resolved,
  pkcs11Support ? false,
  pkcs11helper,
  nixosTests,
  unixtools,
}:

let
  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openvpn";
  version = "2.6.14";

  src = fetchurl {
    url = "https://swupdate.openvpn.net/community/releases/openvpn-${finalAttrs.version}.tar.gz";
    hash = "sha256-nramYYNS+ee3canTiuFjG17f7tbUAjPiQ+YC3fIZXno=";
  };

  # Effectively a backport of https://github.com/OpenVPN/openvpn/commit/1d3c2b67a73a0aa011c13e62f876d24e49d41df0
  # to fix build on linux-headers 6.16.
  # FIXME: remove in next update
  patches = [
    ./dco.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    unixtools.route
    unixtools.ifconfig
  ];

  buildInputs = [
    lz4
    lzo
    openssl
  ]
  ++ optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    libnl
    pam
  ]
  ++ optional useSystemd systemd
  ++ optional pkcs11Support pkcs11helper;

  configureFlags =
    optional useSystemd "--enable-systemd"
    ++ optional pkcs11Support "--enable-pkcs11"
    ++ optional stdenv.hostPlatform.isDarwin "--disable-plugin-auth-pam";

  # We used to vendor the update-systemd-resolved script inside libexec,
  # but a separate package was made, that uses libexec/openvpn. Copy it
  # into libexec in case any consumers expect it to be there even though
  # they should use the update-systemd-resolved package instead.
  postInstall = ''
    mkdir -p $out/share/doc/openvpn/examples
    cp -r sample/sample-{config-files,keys,scripts}/ $out/share/doc/openvpn/examples
  ''
  + optionalString useSystemd ''
    install -Dm555 -t $out/libexec ${update-systemd-resolved}/libexec/openvpn/*
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (nixosTests) initrd-network-openvpn systemd-initrd-networkd-openvpn;
  };

  meta = with lib; {
    description = "Robust and highly flexible tunneling application";
    downloadPage = "https://openvpn.net/community-downloads/";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "openvpn";
  };
})
