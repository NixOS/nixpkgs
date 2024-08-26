{
  mkKdeDerivation,
  substituteAll,
  pkg-config,
  qtwebengine,
  mobile-broadband-provider-info,
  openconnect,
  openvpn,
  strongswan
}:
mkKdeDerivation {
  pname = "plasma-nm";

  patches = [
    (substituteAll {
      src = ./0002-openvpn-binary-path.patch;
      inherit openvpn;
    })
    (substituteAll {
      src = ./0003-strongswan-binary-path.patch;
      inherit strongswan;
    })
  ];

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [
    qtwebengine
    mobile-broadband-provider-info
    openconnect
  ];
}
