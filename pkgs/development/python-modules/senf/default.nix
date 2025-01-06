{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  hypothesis,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "senf";
  version = "1.5.0-unstable-2024-11-26";

  src = fetchFromGitHub {
    owner = "quodlibet";
    repo = "senf";
    rev = "b32bb8091f7b46679a23b3f9e9a9157eaa53be95";
    hash = "sha256-JoFmQkjau8e8EXiJbWS7vnv1FarwerO4vGInosxlNEM=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  disabledTests = [
    # Both don't work even with HOME specified...
    "test_getuserdir"
    "test_expanduser_user"
  ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  pythonImportsCheck = [ "senf" ];

  meta = {
    description = "Consistent filename handling for all Python versions and platforms";
    homepage = "https://senf.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cab404 ];
  };

}
