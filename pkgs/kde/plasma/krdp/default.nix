{
  lib,
  mkKdeDerivation,
  replaceVars,
  openssl,
  pkg-config,
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
    qtwayland
    freerdp
    wayland
    wayland-protocols
  ];
}
