{ buildPythonPackage
, lib
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "4.2.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YNt4YwkuA3DVq4EjJaIES9V3A6ENa3k6/qVKisjA5Pc=";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A wrapper around the stdlib `tokenize` which roundtrips";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
