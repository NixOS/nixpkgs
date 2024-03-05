{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ioc-scan";
  version = "1.5.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "ioc-scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-LQljpIlTDy1uxuwj1WyygwrB5hQ7dib1ViB+SEhRJ6Y=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov" ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    docopt
  ];

  nativeCheckInputs = with python3.pkgs; [
    pyfakefs
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ioc_scan"
  ];

  meta = with lib; {
    description = "Tool to search a filesystem for indicators of compromise (IoC)";
    homepage = "https://github.com/cisagov/ioc-scanner";
    changelog = "https://github.com/cisagov/ioc-scanner/releases/tag/v${version}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
