{ lib
, rustPlatform
, yabridge
, makeWrapper
, wine
}:

rustPlatform.buildRustPackage rec {
  pname = "yabridgectl";
  version = yabridge.version;

  src = yabridge.src;
  sourceRoot = "source/tools/yabridgectl";
  cargoSha256 = "sha256-pwy2Q2HUCihr7W81hGvDm9EiZHk9G8knSy0yxPy6hl8=";

  patches = [
    # By default, yabridgectl locates libyabridge.so by using
    # hard coded distro specific lib paths. This patch replaces those
    # hard coded paths with lib paths from NIX_PROFILES.
    ./libyabridge-from-nix-profiles.patch
  ];

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram "$out/bin/yabridgectl" \
      --prefix PATH : ${lib.makeBinPath [ wine ]}
  '';

  meta = with lib; {
    description = "A small, optional utility to help set up and update yabridge for several directories at once";
    homepage = "https://github.com/robbert-vdh/yabridge/tree/master/tools/yabridgectl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = yabridge.meta.platforms;
  };
}
