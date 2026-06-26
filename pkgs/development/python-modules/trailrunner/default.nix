{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pathspec,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "trailrunner";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "trailrunner";
    tag = "v${version}";
    hash = "sha256-qtEBr22yyj6WcSfyYr/4r0IuuMJ6chFFqnmb+uMfQPA=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ pathspec ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "trailrunner" ];

  meta = {
    description = "Module to walk paths and run things";
    homepage = "https://github.com/omnilib/trailrunner";
    changelog = "https://github.com/omnilib/trailrunner/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
