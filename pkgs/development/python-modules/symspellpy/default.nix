{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  pythonOlder,

  pytestCheckHook,

  setuptools,

  # for testing
  numpy,
  importlib-resources,

  # requirements
  editdistpy,
}:

buildPythonPackage rec {
  pname = "symspellpy";
  version = "6.7.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  patches = [
    # patch for fix tests
    # https://github.com/mammothb/symspellpy/pull/151
    (fetchpatch {
      name = "fix-pkg-resources-deprecation-warning.patch";
      url = "https://github.com/mammothb/symspellpy/commit/b0298f4936f28a79612f5509612210868548793f.patch";
      hash = "sha256-mdUJMrcPv5zczIRP+8u5vicz2IE1AUN3YP0+zg3jqZg=";
    })
    (fetchpatch {
      name = "fix-error-message-checking-py312.patch";
      url = "https://github.com/mammothb/symspellpy/commit/f6f91e18316bed717036306c33d2ee82a922563a.patch";
      hash = "sha256-a5KsESIEIzlbcEPq8sTB2+XkuT/vP81U8StZhaL0MbA=";
    })
  ];

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "symspellpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-D8xdMCy4fSff3nuS2sD2QHWk0869AlFDE+lFRvayYDQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ editdistpy ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    importlib-resources
  ];

  pythonImportsCheck = [
    "symspellpy"
    "symspellpy.symspellpy"
  ];

  meta = with lib; {
    description = "Python port of SymSpell v6.7.1, which provides much higher speed and lower memory consumption";
    homepage = "https://github.com/mammothb/symspellpy";
    changelog = "https://github.com/mammothb/symspellpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
