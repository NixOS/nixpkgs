{ lib
, isPy27
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tls-parser";
  version = "1.2.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = "tls_parser";
    rev = version;
    sha256 = "12qj3vg02r5a51w6gbgb1gcxicqc10lbbsdi57jkkfvbqiindbd0";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/tls_parser";
    description = "Small library to parse TLS records";
    platforms = with platforms; linux ++ darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
