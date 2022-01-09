{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "csv-diff";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "sha256-gKdVyW5LYAGfpnComGi93atHoHGYu95QchKklYLsBe0=";
  };

  # We shouldn't need pytest-runner to build or install the package given that
  # we are using pytestCheckHook
  postPatch = ''
    sed -e "/pytest-runner/d" -i setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    click
    dictdiffer
  ];

  checkInputs = [
    python3.pkgs.pytestCheckHook
  ];

  meta = with lib; {
    description = "Python CLI tool and library for diffing CSV and JSON files";
    homepage = "https://github.com/simonw/csv-diff";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidwilemski ];
  };
}
