{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shot-scraper";
  version = "1.1.1";
  format = "setuptools";

  disabled = python3.pkgs.pythonOlder "3.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-YfWiy44rCRXK5xVkmA9X7pAlDhZrk6nS9vbC2eYvjbg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-default-group
    playwright
    pyyaml
  ];

  # skip tests due to network access
  doCheck = false;

  pythonImportsCheck = [
    "shot_scraper"
  ];

  meta = with lib; {
    description = "A command-line utility for taking automated screenshots of websites";
    homepage = "https://github.com/simonw/shot-scraper";
    changelog = "https://github.com/simonw/shot-scraper/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
