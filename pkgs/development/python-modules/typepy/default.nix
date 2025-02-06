{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mbstrdecoder,
  python-dateutil,
  pytz,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tcolorpy,
}:

buildPythonPackage rec {
  pname = "typepy";
  version = "1.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-lgwXoEtv2nBRKiWQH5bDrAIfikKN3cOqcHLEdnSAMpc=";
  };

  propagatedBuildInputs = [ mbstrdecoder ];

  optional-dependencies = {
    datetime = [
      python-dateutil
      pytz
      packaging
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    tcolorpy
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "typepy" ];

  meta = with lib; {
    description = "Library for variable type checker/validator/converter at a run time";
    homepage = "https://github.com/thombashi/typepy";
    changelog = "https://github.com/thombashi/typepy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}
