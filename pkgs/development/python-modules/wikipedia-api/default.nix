{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wikipedia-api";
  version = "0.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "martin-majlis";
    repo = "Wikipedia-API";
    tag = "v${version}";
    hash = "sha256-5wi1HVkD36RnmIAKSKRYTc30HtYMiFrRoYzZRWENd/M=";
  };

  propagatedBuildInputs = [ requests ];

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
