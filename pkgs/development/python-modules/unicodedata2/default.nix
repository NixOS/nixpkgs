{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "16.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version pname;
    sha256 = "05488d6592b59cd78b61ec37d38725416b2df62efafa6a0d63a631b27aa474fc";
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
