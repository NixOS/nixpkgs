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
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brunobord";
    repo = pname;
    rev = version;
    hash = "sha256-3DyPBgiyMOqoKM7pViHrRLkL52P9XwqYvGZ5Rr0LFeI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ mock skyfield ];

  meta = with lib; {
    homepage = "https://github.com/brunobord/skyfield-data";
    description = "Minimal data files to work with python-skyfield";
    license = licenses.mit;
    maintainers = with maintainers; [ matrss ];
  };
}
