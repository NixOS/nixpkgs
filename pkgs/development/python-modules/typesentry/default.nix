{ lib
, buildPythonPackage
, fetchFromGitHub
, colorama
, pytest
, pytest-cov
}:

buildPythonPackage {
  pname = "typesentry";
  version = "0.2.7";

  # Only wheel distribution is available on PyPi.
  src = fetchFromGitHub {
    owner = "h2oai";
    repo = "typesentry";
    rev = "0ca8ed0e62d15ffe430545e7648c9a9b2547b49c";
    sha256 = "0z615f9dxaab3bay3v27j7q99qm6l6q8xv872yvsp87sxj7apfki";
  };

  propagatedBuildInputs = [ colorama ];
  nativeCheckInputs = [ pytest pytest-cov ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python 2.7 & 3.5+ runtime type-checker";
    homepage = "https://github.com/h2oai/typesentry";
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
