{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,
  setuptools,
  hkdf,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spake2";
  version = "0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wXphSynuQSYgbiIYH3CkBsYY08bGLKbWd5vOlenJJvQ=";
  };

  patches = [
    # https://github.com/warner/python-spake2/pull/16
    (fetchpatch2 {
      name = "python312-compat.patch";
      url = "https://github.com/warner/python-spake2/commit/1b04d33106b105207c97c64b2589c45790720b0b.patch";
      hash = "sha256-OoBz0lN17VyVGg6UfT+Zj9M1faFTNpPIhxrwCgUwMc8=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ hkdf ];

  pythonImportsCheck = [ "spake2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/warner/python-spake2/blob/v${version}/NEWS";
    description = "SPAKE2 password-authenticated key exchange library";
    homepage = "https://github.com/warner/python-spake2";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
