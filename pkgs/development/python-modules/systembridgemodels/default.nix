{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  incremental,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.0.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    rev = "refs/tags/${version}";
    hash = "sha256-iFJ95ouhfbaC0D2Gkc1KO+JueYTFTOj1unnYSDyPAe8=";
  };

  postPatch = ''
    substituteInPlace systembridgemodels/_version.py \
      --replace-fail ", dev=1" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ incremental ];

  pythonImportsCheck = [ "systembridgemodels" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-models/releases/tag/${version}";
    description = "This is the models package used by the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
