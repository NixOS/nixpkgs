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
}:

let
  runtimeDeps = lib.makeBinPath [
    coreutils
    snapper
    util-linux
  ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-assistant";
  version = "1.8";

  src = fetchFromGitLab {
    owner = "btrfs-assistant";
    repo = "btrfs-assistant";
    rev = finalAttrs.version;
    hash = "sha256-Ay2wxDVue+tG09RgAo4Zg2ktlq6dk7GdIwAlbuVULB4=";
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
      --replace '/bin/bash' "${bash}/bin/bash"

     substituteInPlace src/main.cpp \
      --replace '/usr/bin/snapper' "${snapper}/bin/snapper"
  '';

  postPatch = ''
    substituteInPlace src/org.btrfs-assistant.pkexec.policy \
      --replace '/usr/bin' "$out/bin"

    substituteInPlace src/btrfs-assistant \
      --replace 'btrfs-assistant-bin' "$out/bin/btrfs-assistant-bin"

    substituteInPlace src/btrfs-assistant-launcher \
      --replace 'btrfs-assistant' "$out/bin/btrfs-assistant"

    substituteInPlace src/btrfs-assistant.conf \
      --replace '/usr/bin/snapper' "${snapper}/bin/snapper"
  '';

  qtWrapperArgs = [
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
