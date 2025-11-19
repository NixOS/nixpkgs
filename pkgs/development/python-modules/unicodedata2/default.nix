{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "17.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-/6Lw1oNGQv6ZbTVuco2ohyAVM7tUCXSuesl15m7MDjo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unicodedata2" ];

  meta = with lib; {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    changelog = "https://github.com/fonttools/unicodedata2/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
