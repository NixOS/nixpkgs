{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "17.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-15lD0VP19r++P1Wl7GEZhRhL2jf87bPsx1Mi2CrmrTs=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unicodedata2" ];

  meta = {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    changelog = "https://github.com/fonttools/unicodedata2/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
