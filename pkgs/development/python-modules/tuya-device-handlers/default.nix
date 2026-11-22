{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pyprojectVersionPatchHook,
  tuya-device-sharing-sdk,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "tuya-device-handlers";
  version = "0.0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "tuya-device-handlers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0O3v43Veqxvnwt5bSJ9ZkLjE5TmNWljNOOO1Srd4NBs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.13,<0.14' uv_build
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ uv-build ];

  dependencies = [ tuya-device-sharing-sdk ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # pathlib.Path(path).relative_to(_PROJECT_ROOT) evaluates to a path that is not below the build dir
    "test_customer_device_with_quirk_as_dict"
  ];

  pythonImportsCheck = [ "tuya_device_handlers" ];

  meta = {
    description = "Tuya quirks library";
    homepage = "https://github.com/home-assistant-libs/tuya-device-handlers";
    changelog = "https://github.com/home-assistant-libs/tuya-device-handlers/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
