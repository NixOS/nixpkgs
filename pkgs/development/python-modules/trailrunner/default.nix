{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pathspec,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "trailrunner";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "trailrunner";
    rev = "refs/tags/v${version}";
    hash = "sha256-qtEBr22yyj6WcSfyYr/4r0IuuMJ6chFFqnmb+uMfQPA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ pathspec ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "trailrunner" ];

  meta = with lib; {
    description = "Module to walk paths and run things";
    homepage = "https://github.com/omnilib/trailrunner";
    changelog = "https://github.com/omnilib/trailrunner/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
