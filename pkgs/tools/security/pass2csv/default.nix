{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "pass2csv";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IdcSwQ9O2HmCvT8p4tC7e2GQuhkE3kvMINszZH970og=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    python-gnupg
  ];

  # Project has no tests.
  doCheck = false;

  meta = with lib; {
    description = "Export pass(1), \"Standard unix password manager\", to CSV";
    mainProgram = "pass2csv";
    homepage = "https://github.com/reinefjord/pass2csv";
    license = licenses.mit;
    maintainers = [ ];
  };
}
