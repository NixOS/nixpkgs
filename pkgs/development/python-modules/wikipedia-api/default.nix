{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wikipedia-api";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martin-majlis";
    repo = "Wikipedia-API";
    tag = "v${version}";
    hash = "sha256-5wi1HVkD36RnmIAKSKRYTc30HtYMiFrRoYzZRWENd/M=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wikipediaapi" ];

  meta = with lib; {
    description = "Python wrapper for Wikipedia";
    homepage = "https://github.com/martin-majlis/Wikipedia-API";
    changelog = "https://github.com/martin-majlis/Wikipedia-API/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
