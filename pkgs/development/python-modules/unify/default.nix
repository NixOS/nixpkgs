{ lib
, buildPythonPackage
, fetchFromGitHub
, untokenize
, python
}:

buildPythonPackage rec {
  pname = "unify";
  version = "0.5";

  # PyPi release is missing tests (see https://github.com/myint/unify/pull/18)
  src = fetchFromGitHub {
    owner = "myint";
    repo = "unify";
    rev = "v${version}";
    sha256 = "1l6xxygaigacsxf0g5f7w5gpqha1ava6mcns81kqqy6vw91pyrbi";
  };

  propagatedBuildInputs = [ untokenize ];

  checkPhase = "${python.interpreter} -m unittest discover";

  meta = with lib; {
    description = "Modifies strings to all use the same quote where possible";
    homepage = "https://github.com/myint/unify";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
