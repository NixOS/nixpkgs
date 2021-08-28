{ lib, buildPythonPackage, fetchFromGitHub, attrs, pytestCheckHook }:

buildPythonPackage rec {
  pname = "sumtypes";
  version = "0.1a5";

  src = fetchFromGitHub {
    owner = "radix";
    repo = "sumtypes";
    rev = version;
    sha256 = "0wcw1624xxx2h6lliv13b59blg60j8sgf5v2ni3cwx3j4wld4csr";
  };

  propagatedBuildInputs = [ attrs ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Algebraic data types for Python";
    homepage = "https://github.com/radix/sumtypes";
    license = licenses.mit;
    maintainers = with maintainers; [ NieDzejkob ];
  };
}
