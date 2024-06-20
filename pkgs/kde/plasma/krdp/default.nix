{
  lib,
  mkKdeDerivation,
  substituteAll,
  openssl,
  pkg-config,
  qtkeychain,
  qtwayland,
  freerdp,
  wayland,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "krdp";

  patches = [
    (substituteAll {
      src = ./hardcode-openssl-path.patch;
      openssl = lib.getExe openssl;
    })
  ];

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [
    qtkeychain
    qtwayland
    freerdp
    wayland
    wayland-protocols
  ];
}
