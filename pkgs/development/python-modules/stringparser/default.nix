{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "stringparser";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = pname;
    rev = version;
    sha256 = "sha256-uyeHuH0UfpZqh7sMRI6+fR/Rr2jSzdR+5O/MtzslO5w=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];

  pythonImportsCheck = [ "stringparser" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Easy to use pattern matching and information extraction";
    homepage = "https://github.com/hgrecco/stringparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evilmav ];
  };
}
