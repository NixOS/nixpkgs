{
  lib,
  bleak,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "okokscale";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "rrooggiieerr";
    repo = "okokscale.py";
    tag = finalAttrs.version;
    hash = "sha256-nLPV1vTKWWZ/e19/WWxSDeYdYP42MjhMhN8IzrztigI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling>=1.32.4" "hatchling"
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    bleak
    bluetooth-sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "okokscale" ];

  meta = {
    description = "Library for parsing OKOK scale BLE advertisements";
    homepage = "https://github.com/rrooggiieerr/okokscale.py";
    changelog = "https://github.com/rrooggiieerr/okokscale.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
