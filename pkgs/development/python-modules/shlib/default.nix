{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, braceexpand
, inform
}:

buildPythonPackage rec {
  pname = "shlib";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "shlib";
    rev = "v${version}";
    sha256 = "sha256-2fwRxa64QXKJuhYwt9Z4BxhTeq1iwbd/IznfxPUjeSM=";
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
