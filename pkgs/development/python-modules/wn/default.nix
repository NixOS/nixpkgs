{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, flit-core
, requests
, tomli
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.9.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TghCKPKLxRTpvojmZi8tPGmU/D2W+weZl64PArAwDCE=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    requests
    tomli
  ];

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "wn" ];

  meta = with lib; {
    description = "A modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
