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
      src = ./0000-binary-path.patch;
      inherit openvpn strongswan;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtwebengine
    mobile-broadband-provider-info
    openconnect
  ];
}
