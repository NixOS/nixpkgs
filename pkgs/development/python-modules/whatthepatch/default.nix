{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cscorley";
    repo = pname;
    rev = version;
    hash = "sha256-0l/Ebq7Js9sKFJ/RzkQ1aWEDCxt+COVd2qVnLSWwFx0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "whatthepatch" ];

  meta = with lib; {
    description = "Python library for both parsing and applying patch files";
    homepage = "https://github.com/cscorley/whatthepatch";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
