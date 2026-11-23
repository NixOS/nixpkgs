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
  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
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
  version = "2.6.23";

  src = fetchurl {
    url = "https://swupdate.openvpn.net/community/releases/openvpn-${finalAttrs.version}.tar.gz";
    hash = "sha256-QEHHCRYr7BMlq/WqjPJ6JVzEd8Y0sV7jEEEccB/ECpY=";
  };

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
  ++ optional useSystemd systemdLibs
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
    inherit (nixosTests) initrd-network-openvpn;
  };

  meta = {
    description = "Robust and highly flexible tunneling application";
    downloadPage = "https://openvpn.net/community-downloads/";
    homepage = "https://openvpn.net/";
    changelog =
      let
        # The changelog moves in v2.7.9, released 5 November 2026, although
        # Nixpkgs is still on 2.6.23.  Future-proof the URL by handling both
        # locations.  The conditional test can be removed once we've updated to
        # v2.7.9.
        ext = if lib.versionAtLeast finalAttrs.version "2.7.9" then "md" else "rst";
      in
      "https://github.com/OpenVPN/openvpn/blob/v${finalAttrs.version}/Changes.${ext}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "openvpn";
  };
})
