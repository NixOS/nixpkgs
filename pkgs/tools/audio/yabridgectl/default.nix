{ lib
, rustPlatform
, yabridge
, makeWrapper
, wine
}:

rustPlatform.buildRustPackage {
  pname = "yabridgectl";
  version = yabridge.version;

  src = yabridge.src;
  sourceRoot = "${yabridge.src.name}/tools/yabridgectl";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "reflink-0.1.3" = "sha256-1o5d/mepjbDLuoZ2/49Bi6sFgVX4WdCuhGJkk8ulhcI=";
    };
  };

  patches = [
    # Patch yabridgectl to search for the chainloader through NIX_PROFILES
    ./chainloader-from-nix-profiles.patch

    # Dependencies are hardcoded in yabridge, so the check is unnecessary and likely incorrect
    ./remove-dependency-verification.patch
  ];

  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram "$out/bin/yabridgectl" \
      --prefix PATH : ${lib.makeBinPath [
        wine # winedump
      ]}
  '';

  meta = with lib; {
    description = "A small, optional utility to help set up and update yabridge for several directories at once";
    homepage = "${yabridge.src.meta.homepage}/tree/${yabridge.version}/tools/yabridgectl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = yabridge.meta.platforms;
  };
}
