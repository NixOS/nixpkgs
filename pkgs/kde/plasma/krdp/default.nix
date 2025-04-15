{
  lib,
  mkKdeDerivation,
  replaceVars,
  openssl,
  pkg-config,
  qtwayland,
  freerdp,
  fetchpatch,
  wayland,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "krdp";

  patches = [
    (replaceVars ./hardcode-openssl-path.patch {
      openssl = lib.getExe openssl;
    })
    (fetchpatch {
      # support for freerdp3, can be dropped with krdp 6.4
      url = "https://invent.kde.org/plasma/krdp/-/merge_requests/69.patch";
      hash = "sha256-5x9JUbFTw/POxBW8G/BOlo/wtcUjPU9J1V/wba1EI/o=";
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
