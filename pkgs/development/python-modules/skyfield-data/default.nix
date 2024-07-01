{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, setuptools
, skyfield
}:

buildPythonPackage rec {
  pname = "skyfield-data";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brunobord";
    repo = pname;
    rev = version;
    hash = "sha256-BJhyZlrf9HHUO5VvPiLgpkFnuN4sJcfqX06YEyyvC+M=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ mock skyfield ];

  disabledTests = [
    "test_current_expiration_date"
  ];

  meta = with lib; {
    homepage = "https://github.com/brunobord/skyfield-data";
    description = "Minimal data files to work with python-skyfield";
    license = licenses.mit;
    maintainers = with maintainers; [ matrss ];
  };
}
