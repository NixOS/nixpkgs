{ buildPythonPackage
, mbstrdecoder
, python-dateutil
, pytz
, packaging

, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "typepy";
  version = "1.3.0";

  propagatedBuildInputs = [ mbstrdecoder python-dateutil pytz packaging ];
  doCheck = false;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-J6SgVd2m0wOVr2ZV/pryRcJrn+BYTGstAUQO349c2lE=";
  };

  meta = with lib; {
    homepage = "https://github.com/thombashi/typepy";
    description = "typepy is a Python library for variable type checker/validator/converter at a run time";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
