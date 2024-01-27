{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hstsparser";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thebeanogamer";
    repo = "hstsparser";
    rev = "refs/tags/${version}";
    hash = "sha256-9ZNBzPa4mFXbao73QukEL56sM/3dg4ElOMXgNGTVh1g=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    prettytable
  ];

  pythonImportsCheck = [
    "hstsparser"
  ];

  meta = with lib; {
    description = "Tool to parse Firefox and Chrome HSTS databases into forensic artifacts";
    homepage = "https://github.com/thebeanogamer/hstsparser";
    changelog = "https://github.com/thebeanogamer/hstsparser/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
