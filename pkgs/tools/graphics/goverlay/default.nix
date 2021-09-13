{ lib
, writeScriptBin
, bash
, stdenv
, fetchFromGitHub
, fpc
, lazarus-qt
, wrapQtAppsHook
, libGL
, libGLU
, libqt5pas
, libX11
, coreutils
, git
, gnugrep
, libnotify
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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = pname;
    rev = version;
    hash = "sha256-ZksQse0xWAtH+U6EjcGWT2BOG5dfSnm6XvZLLE5ynHs=";
  };

  outputs = [ "out" "man" ];

  patches = [
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
    wrapQtAppsHook
  ];

  buildInputs = [
    libGL
    libGLU
    libqt5pas
    libX11
  ];

  NIX_LDFLAGS = "-lGLU -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    runHook preBuild
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt}/share/lazarus -B goverlay.lpi
    runHook postBuild
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [
      bash
      coreutils
      find-xdg-data-files
      git
      gnugrep
      libnotify
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
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
