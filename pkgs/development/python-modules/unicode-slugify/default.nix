{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pytestCheckHook,
  six,
  unidecode,
}:

buildPythonPackage rec {
  pname = "unicode-slugify";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25f424258317e4cb41093e2953374b3af1f23097297664731cdb3ae46f6bd6c3";
  };

  patches = [
    ./use_pytest_instead_of_nose.patch
    # mozilla/unicode-slugify#41: Fix Python 3.12 SyntaxWarning
    (fetchpatch {
      url = "https://github.com/mozilla/unicode-slugify/commit/a18826f440d0b74e536f5e32ebdcf30e720f20d8.patch";
      hash = "sha256-B27psp0XI5GhoR0l5lFpUOh88hHzjJYzJS5PnIkfFws=";
    })
  ];

  propagatedBuildInputs = [
    six
    unidecode
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "slugify/tests.py" ];

  meta = with lib; {
    description = "Generates unicode slugs";
    homepage = "https://pypi.org/project/unicode-slugify/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
