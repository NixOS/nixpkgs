{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  webencodings,
  pytestCheckHook,
  flit-core,
}:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kozea";
    repo = "tinycss2";

    rev = "v1.4.0";
    # for tests
    fetchSubmodules = true;
    hash = "sha256-GVymUobWAE0YS65lti9dXRIIGpx0YkwF/vSb3y7cpYY=";
  };

  build-system = [ flit-core ];
  dependencies = [ webencodings ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
