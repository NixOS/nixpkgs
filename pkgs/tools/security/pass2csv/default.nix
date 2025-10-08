{
  buildPythonApplication,
  fetchPypi,
  lib,
  python-gnupg,
  setuptools,
}:

buildPythonApplication rec {
  pname = "pass2csv";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IdcSwQ9O2HmCvT8p4tC7e2GQuhkE3kvMINszZH970og=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-gnupg
  ];

  # Project has no tests.
  doCheck = false;

  meta = with lib; {
    description = "Export pass(1), \"Standard unix password manager\", to CSV";
    mainProgram = "pass2csv";
    homepage = "https://codeberg.org/svartstare/pass2csv";
    license = licenses.mit;
    maintainers = [ ];
  };
}
