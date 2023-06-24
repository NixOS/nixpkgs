{ buildPythonPackage
, fetchFromGitHub
, lib
, mbstrdecoder
, python-dateutil
, pytz
, packaging
, pytestCheckHook
, tcolorpy
}:

buildPythonPackage rec {
  pname = "typepy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cgy1+6RZ1DUyH45bAKpGPOOZCwhCUghummw2fnfJGww=";
  };

  propagatedBuildInputs = [ mbstrdecoder python-dateutil pytz packaging ];

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [ tcolorpy ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/typepy";
    description = "A library for variable type checker/validator/converter at a run time";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
