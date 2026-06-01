{
  buildPythonPackage,
  fetchFromBitbucket,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zcc-helper";
  version = "3.8";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "mark_hannon";
    repo = "zcc";
    rev = "release_${version}";
    hash = "sha256-8jbDhlYIgmC0U6w9UY6PGvCnSDFiC/uBib08fikeabk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zcc" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://bitbucket.org/mark_hannon/zcc/src/${src.rev}/CHANGELOG.md";
    description = "ZIMI ZCC helper module";
    homepage = "https://bitbucket.org/mark_hannon/zcc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
