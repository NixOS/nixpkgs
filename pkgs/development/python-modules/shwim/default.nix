{
  attrs,
  buildPythonPackage,
  click,
  copyDesktopItems,
  fetchFromGitHub,
  fetchurl,
  fowl,
  hatchling,
  lib,
  magic-wormhole,
  makeBinaryWrapper,
  makeDesktopItem,
  tty-share,
  twisted,
}:
buildPythonPackage rec {
  pname = "shwim";
  version = "25.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meejah";
    repo = "shwim";
    tag = version;
    hash = "sha256-620aaZcjDmtrjlrH+VyZ5LRS1xzqlPbBJdqEOWQo8vI=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  dependencies = [
    twisted
    attrs
    click
    fowl
    magic-wormhole
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ tty-share ]}"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "shwim";
      exec = "shwim";
      icon = "shwim";
      desktopName = "Shwim";
      comment = "Share terminal sessions over magic wormhole";
      categories = [
        "System"
        "Utility"
        "TerminalEmulator"
      ];
      terminal = true;
    })
  ];

  postInstall = ''
    # Install icon
    install -Dm644 ${
      fetchurl {
        url = "https://github.com/meejah/shwim/raw/main/media/logo-shell-256.png";
        hash = "sha256-iOeWPfEHh4Kemb0n7UMQuYqJo4JixABGXtfatyZ+I5I=";
      }
    } $out/share/pixmaps/shwim.png
  '';

  pythonImportsCheck = [ "shwim" ];

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/shwim --help | grep Usage
    runHook postInstallCheck
  '';

  meta = {
    description = "Share terminal sessions over magic wormhole";
    homepage = "https://github.com/meejah/shwim";
    license = lib.licenses.mit;
    mainProgram = "shwim";
    maintainers = with lib.maintainers; [ yajo ];
  };
}
