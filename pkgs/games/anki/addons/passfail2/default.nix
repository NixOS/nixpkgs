{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "passfail2";
  version = "0.3.0-unstable-2024-10-17";
  src = fetchFromGitHub {
    owner = "lambdadog";
    repo = "passfail2";
    rev = "d5313e4f1217e968b36edbc0a4fe92386209ffe6";
    hash = "sha256-HMe6/fHpYj/MN0dUFj3W71vK7qqcp9l1xm8SAiKkJLs=";
  };
  buildPhase = ''
    runHook preBuild

    substitute build_info.py.in build_info.py \
      --replace-fail '$version' '"${finalAttrs.version}"'

    runHook postBuild
  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Replaces the default Anki review buttons with only two options:
      “Fail” and “Pass”
    '';
    homepage = "https://github.com/lambdadog/passfail2";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
