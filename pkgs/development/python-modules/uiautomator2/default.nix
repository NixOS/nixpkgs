{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  poetry-core,
  poetry-dynamic-versioning,
  adbutils,
  click,
  lxml,
  pillow,
  requests,
  retry2,
  pytestCheckHook,
  writeShellApplication,
  curl,
  buildPackages,
  nix,
  coreutils,
  gnused,
}:

let
  sources = lib.importJSON ./sources.json;
in
buildPythonPackage (finalAttrs: {
  pname = "uiautomator2";
  inherit (sources) version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openatx";
    repo = "uiautomator2";
    tag = finalAttrs.version;
    hash = sources.sourceHash;
  };

  # uiautomator2 installs these helpers on the phone
  serverJar = fetchurl {
    url = "https://github.com/openatx/android-uiautomator-server-jar/releases/download/${sources.serverJar.version}/u2.jar";
    hash = sources.serverJar.hash;
  };
  serverApk = fetchurl {
    url = "https://github.com/openatx/android-uiautomator-server/releases/download/${sources.serverApk.version}/app-uiautomator.apk";
    hash = sources.serverApk.hash;
  };

  postPatch = ''
    # verify that the jar and apk versions match
    grep -Fx 'JAR_VERSION="${sources.serverJar.version}"' uiautomator2/assets/sync.sh
    grep -Fx "__apk_version__ = '${sources.serverApk.version}'" uiautomator2/version.py
    cp "$serverJar" uiautomator2/assets/u2.jar
    cp "$serverApk" uiautomator2/assets/app-uiautomator.apk
  '';

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  env.POETRY_DYNAMIC_VERSIONING_BYPASS = finalAttrs.version;

  dependencies = [
    adbutils
    click
    lxml
    pillow
    requests
    retry2
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # skip mobile_tests and demo_tests because they require a connected android device
  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # this test expects exit 0 when no command is given, but the packaged
    # version of Click returns exit 2
    "test_missing_command_shows_help"
  ];

  pythonImportsCheck = [ "uiautomator2" ];

  passthru.updateScript = [
    (lib.getExe (writeShellApplication {
      name = "update-uiautomator2";
      runtimeInputs = [
        curl
        buildPackages.jq
        nix
        coreutils
        gnused
      ];
      text = builtins.readFile ./update.sh;
    }))
    (toString ./sources.json)
  ];

  meta = {
    description = "Uiautomator for android device";
    homepage = "https://github.com/openatx/uiautomator2";
    changelog = "https://github.com/openatx/uiautomator2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "uiautomator2";
  };
})
