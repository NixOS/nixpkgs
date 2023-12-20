{ buildPythonPackage
, lib
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tokenize-rt";
  version = "4.2.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YNt4YwkuA3DVq4EjJaIES9V3A6ENa3k6/qVKisjA5Pc=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A wrapper around the stdlib `tokenize` which roundtrips";
    homepage = "https://github.com/asottile/tokenize-rt";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
