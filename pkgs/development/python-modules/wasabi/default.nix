{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4a36aaa9ca3a151f0c558f269d442afbb3526f0160fd541acd8a0d5e5712054";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    changelog = "https://github.com/ines/wasabi/releases/tag/v${version}";
    license = licenses.mit;
  };
}
