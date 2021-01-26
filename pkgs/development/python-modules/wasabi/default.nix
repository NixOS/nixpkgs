{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e5228a51f5550844ef5080e74759e7ecb6e344241989d018686ba968f0b4f5a";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
