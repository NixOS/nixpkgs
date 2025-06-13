{
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  qtwebengine,
  mobile-broadband-provider-info,
  openconnect,
  openvpn,
}:
mkKdeDerivation {
  pname = "plasma-nm";

  patches = [
    (replaceVars ./0002-openvpn-binary-path.patch {
      inherit openvpn;
    })
  ];

  extraNativeBuildInputs = [
    pkg-config
    qtwebengine
  ];

  extraBuildInputs = [
    qtwebengine
    mobile-broadband-provider-info
    openconnect
  ];
}
