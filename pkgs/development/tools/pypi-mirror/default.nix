{
  fetchFromGitHub,
  lib,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pypi-mirror";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "montag451";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-bvnOieNs8pCDKuCSJx88vRxFPcOGWUj/i3mNS6E/nok=";
  };

  pythonImportsCheck = [ "pypi_mirror" ];

  meta = with lib; {
    description = "A script to create a partial PyPI mirror";
    mainProgram = "pypi-mirror";
    homepage = "https://github.com/montag451/pypi-mirror";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
