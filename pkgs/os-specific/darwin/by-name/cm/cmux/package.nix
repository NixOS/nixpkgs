{
  lib,
  stdenvNoCC,
  _7zz,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cmux";
  version = "0.63.2";

  src = fetchurl {
    url = "https://github.com/manaflow-ai/cmux/releases/download/v${finalAttrs.version}/cmux-macos.dmg";
    hash = "sha256-xk2KL1TzS7tCL6lA+8AdUlq8AUoJkpLIZtifIGI1qUw=";
  };

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    7zz -snld x $src
    runHook postUnpack
  '';

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    mv cmux.app $out/Applications/
    ln -s ../Applications/cmux.app/Contents/Resources/bin/cmux $out/bin/cmux

    runHook postInstall
  '';

  resourceDir = "${placeholder "out"}/Applications/cmux.app/Contents/Resources";

  postFixup = ''
    mkdir -p $terminfo/share
    cp -r $resourceDir/terminfo $terminfo/share/terminfo

    cp -r $resourceDir/shell-integration $shell_integration
  '';

  outputs = [
    "out"
    "shell_integration"
    "terminfo"
  ];

  passthru.updateScript = nix-update-script {
    attrPath = "darwin.cmux";
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Ghostty-based macOS terminal with vertical tabs and notifications for AI coding agents";
    homepage = "https://www.cmux.dev/";
    downloadPage = "https://github.com/manaflow-ai/cmux/releases";
    changelog = "https://github.com/manaflow-ai/cmux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chandler-barlow ];
    mainProgram = "cmux";
    outputsToInstall = [
      "out"
      "shell_integration"
      "terminfo"
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
