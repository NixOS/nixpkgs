{
  lib,
  mkKdeDerivation,
  replaceVars,
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
    (replaceVars ./hardcode-openssl-path.patch {
      openssl = lib.getExe openssl;
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtkeychain
    qtwayland
    freerdp
    wayland
    wayland-protocols
  ];
}
