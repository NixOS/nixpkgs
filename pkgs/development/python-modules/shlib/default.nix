{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, braceexpand
, inform
}:

buildPythonPackage rec {
  pname = "shlib";
  version = "1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-f2jJgpjybutCpYnIT+RihtoA1YlXdhTs+MvV8bViSMQ=";
  };

  pythonImportsCheck = [ "shlib" ];
  postPatch = ''
    patchShebangs .
  '';
  nativeCheckInputs = [
    pytestCheckHook
  ];
  propagatedBuildInputs = [
    braceexpand
    inform
  ];

  meta = with lib; {
    description = "shell library";
    homepage = "https://github.com/KenKundert/shlib";
    changelog = "https://github.com/KenKundert/shlib/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
