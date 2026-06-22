{
  lib,
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  qtkeychain,
  qtwebengine,
  kirigami-addons,
  mobile-broadband-provider-info,
  openconnect,
  openvpn,
  strongswan,
}:
mkKdeDerivation {
  pname = "plasma-nm";

  patches = [
    (replaceVars ./hardcode-paths.patch {
      openvpn = lib.getExe openvpn;
      ipsec = lib.getExe' strongswan "ipsec";
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtkeychain
    qtwebengine
    mobile-broadband-provider-info
    openconnect
  ];

  extraPropagatedBuildInputs = [ kirigami-addons ];
}
