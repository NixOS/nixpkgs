{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "wtforms-dateutil";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wtforms";
    repo = "wtforms-dateutil";
    rev = version;
    hash = "sha256-k1DZqf2FgyupNvRIIrPLwxbTP5MteCnvASCkpCZRyAE=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.python-dateutil
    python3.pkgs.wtforms
  ];

  pythonImportsCheck = [ "wtforms_dateutil" ];

  meta = with lib; {
    description = "WTForms integration for dateutil";
    homepage = "https://github.com/wtforms/wtforms-dateutil";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "wtforms-dateutil";
  };
}
