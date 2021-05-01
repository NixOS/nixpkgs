{ lib
, writeScriptBin
, bash
, stdenv
, fetchFromGitHub
, fetchpatch
, fpc
, lazarus-qt
, qt5
, libX11
, libqt5pas
, coreutils
, git
, gnugrep
, libnotify
, mesa-demos
, polkit
, procps
, systemd
, vulkan-tools
, which
}:

let
  # Finds data files using the XDG Base Directory Specification
  # See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
  find-xdg-data-files = writeScriptBin "find-xdg-data-files" ''
    #!${bash}/bin/sh
    IFS=:
    for xdg_data_dir in ''${XDG_DATA_HOME:-$HOME/.local/share}:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}; do
      if [ -f "$xdg_data_dir/$1" ]; then
        echo "$xdg_data_dir/$1"
      fi
    done
  '';
in stdenv.mkDerivation rec {
  pname = "goverlay";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = pname;
    rev = version;
    hash = "sha256-qS0GY2alUBfkmT20oegGpkhVkK+ZOUkJCPSV/wt0ZUA=";
  };

  patches = [
    # Find replay-sorcery in PATH
    # See https://github.com/benjamimgois/goverlay/pull/123
    (fetchpatch {
      url = "https://github.com/benjamimgois/goverlay/commit/09da4db26196f42578b11bd6541be5ede1125cdf.patch";
      sha256 = "sha256-qYxAe5okKwRfmk7IBVq0nl6RUddKjge+TKzah+0VfeQ=";
    })

    # Support running previews without MangoHud
    # See https://github.com/benjamimgois/goverlay/pull/124
    (fetchpatch {
      url = "https://github.com/benjamimgois/goverlay/commit/1a7e9eee5113c45e93000dfd41f79b36fd169475.patch";
      sha256 = "sha256-qTRuULv/NLuZLdejC34JS1T+jKvdRyVQSzCBXtOaRME=";
    })

    # Find MangoHud & vkBasalt Vulkan layers using the XDG Base Directory Specification
    ./find-xdg-data-files.patch
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'prefix = /usr/local' "prefix = $out"

    substituteInPlace overlayunit.pas \
      --replace '/usr/share/icons/hicolor/128x128/apps/goverlay.png' "$out/share/icons/hicolor/128x128/apps/goverlay.png"
  '';

  nativeBuildInputs = [
    fpc
    lazarus-qt
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libX11
    libqt5pas
  ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt}/share/lazarus -B goverlay.lpi
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      bash
      coreutils
      find-xdg-data-files
      git
      gnugrep
      libnotify
      mesa-demos
      polkit
      procps
      systemd
      vulkan-tools
      which
    ]}"

    # Force xcb since libqt5pas doesn't support Wayland
    # See https://github.com/benjamimgois/goverlay/issues/107
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = with lib; {
    description = "An opensource project that aims to create a Graphical UI to help manage Linux overlays";
    homepage = "https://github.com/benjamimgois/goverlay";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
