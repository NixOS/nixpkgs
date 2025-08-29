{
  buildPythonPackage,
  fetchFromBitbucket,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zcc-helper";
  version = "3.6";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "mark_hannon";
    repo = "zcc";
    rev = "release_${version}";
    hash = "sha256-93zSEGr5y00+heuG0hTME+BkLQBUmHnXXMH12ktMtM4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zcc" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "ZIMI ZCC helper module";
    homepage = "https://bitbucket.org/mark_hannon/zcc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
