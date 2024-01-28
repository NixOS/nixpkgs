{ lib
, stdenv
, fetchFromGitLab
, bash
, btrfs-progs
, cmake
, coreutils
, git
, pkg-config
, qtbase
, qtsvg
, qttools
, snapper
, util-linux
, wrapQtAppsHook
, enableSnapper ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-assistant";
  version = "1.9";

  src = fetchFromGitLab {
    owner = "btrfs-assistant";
    repo = "btrfs-assistant";
    rev = finalAttrs.version;
    hash = "sha256-a854WI8f9/G/BRU5rn1FKC6WRZyXNYsUL4p258C8ppw=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    btrfs-progs
    qtbase
    qtsvg
    qttools
  ];

  propagatedBuildInputs = [ wrapQtAppsHook ];

  prePatch = ''
    substituteInPlace src/util/System.cpp \
      --replace '/bin/bash' "${lib.getExe bash}"
  ''
  + lib.optionalString enableSnapper ''
    substituteInPlace src/main.cpp \
      --replace '/usr/bin/snapper' "${lib.getExe snapper}"
  '';

  postPatch = ''
    substituteInPlace src/org.btrfs-assistant.pkexec.policy \
      --replace '/usr/bin' "$out/bin"

    substituteInPlace src/btrfs-assistant \
      --replace 'btrfs-assistant-bin' "$out/bin/btrfs-assistant-bin"

    substituteInPlace src/btrfs-assistant-launcher \
      --replace 'btrfs-assistant' "$out/bin/btrfs-assistant"
  ''
  + lib.optionalString enableSnapper ''
    substituteInPlace src/btrfs-assistant.conf \
      --replace '/usr/bin/snapper' "${lib.getExe snapper}"
  '';

  qtWrapperArgs =
    let
      runtimeDeps = lib.makeBinPath ([
        coreutils
        util-linux
      ]
      ++ lib.optionals enableSnapper [ snapper ]);
    in
    [
      "--prefix PATH : ${runtimeDeps}"
    ];

  meta = {
    description = "A GUI management tool to make managing a Btrfs filesystem easier";
    homepage = "https://gitlab.com/btrfs-assistant/btrfs-assistant";
    license = lib.licenses.gpl3Only;
    mainProgram = "btrfs-assistant-bin";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.linux;
  };
})
