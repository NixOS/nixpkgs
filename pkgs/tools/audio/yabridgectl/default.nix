{ lib, rustPlatform, yabridge }:

rustPlatform.buildRustPackage rec {
  pname = "yabridgectl";
  version = yabridge.version;

  src = yabridge.src;
  sourceRoot = "source/tools/yabridgectl";
  cargoHash = "sha256-mSp/IH7ZB7YSOBCFwNtHLYDz7CvWo2sO9VuPdqpl/u0=";

  patches = [
    # By default, yabridgectl locates libyabridge.so by using
    # hard coded distro specific lib paths. This patch replaces those
    # hard coded paths with lib paths from NIX_PROFILES.
    ./libyabridge-from-nix-profiles.patch
  ];

  patchFlags = [ "-p3" ];

  meta = with lib; {
    description = "A small, optional utility to help set up and update yabridge for several directories at once";
    homepage = "https://github.com/robbert-vdh/yabridge/tree/master/tools/yabridgectl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
  };
}
