{
  mkKdeDerivation,
  replaceVars,
  pkg-config,
  qtwebengine,
  kirigami-addons,
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

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwebengine
    mobile-broadband-provider-info
    openconnect
  ];

  extraPropagatedBuildInputs = [ kirigami-addons ];
}
