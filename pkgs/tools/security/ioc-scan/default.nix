{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ioc-scan";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "ioc-scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-SCyCANZfi7PqexM2Kc8WJwwEEiBQxPBg0ggWsK9WB4k=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail " --cov" ""
  '';

  build-system = with python3.pkgs; [ setuptools ];

  propagatedBuildInputs = with python3.pkgs; [ docopt];

  nativeCheckInputs = with python3.pkgs; [
    pyfakefs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ioc_scan" ];

  meta = with lib; {
    description = "Tool to search a filesystem for indicators of compromise (IoC)";
    homepage = "https://github.com/cisagov/ioc-scanner";
    changelog = "https://github.com/cisagov/ioc-scanner/releases/tag/v${version}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
