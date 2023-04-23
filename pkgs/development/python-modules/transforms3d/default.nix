{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest
, numpy
, scipy
, sympy
}:

buildPythonPackage rec {
  pname = "transforms3d";
  version = "unstable-2019-12-17";

  disabled = isPy27;

  # no Git tag or PyPI release in some time
  src = fetchFromGitHub {
    owner = "matthew-brett";
    repo = pname;
    rev = "6b20250c610249914ca5e3a3a2964c36ca35c19a";
    sha256 = "1z789hgk71a6rj6mqp9srpzamg06g58hs2p1l1p344cfnkj5a4kc";
  };

  propagatedBuildInputs = [ numpy sympy ];

  nativeCheckInputs = [ pytest scipy ];
  checkPhase = "pytest transforms3d";

  meta = with lib; {
    homepage = "https://matthew-brett.github.io/transforms3d";
    description = "Convert between various geometric transformations";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
