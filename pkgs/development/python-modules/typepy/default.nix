{ lib
, buildPythonPackage
, fetchFromGitHub
, mbstrdecoder
, python-dateutil
, pytz
, packaging
, pytestCheckHook
, pythonOlder
, tcolorpy
}:

buildPythonPackage rec {
  pname = "typepy";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cgy1+6RZ1DUyH45bAKpGPOOZCwhCUghummw2fnfJGww=";
  };

  propagatedBuildInputs = [
    mbstrdecoder
  ];

  passthru.optional-dependencies = {
    datetime = [
      python-dateutil
      pytz
      packaging
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    tcolorpy
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "typepy"
  ];

  meta = with lib; {
    description = "Library for variable type checker/validator/converter at a run time";
    homepage = "https://github.com/thombashi/typepy";
    changelog = "https://github.com/thombashi/typepy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}
