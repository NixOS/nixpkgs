{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    rev = "refs/tags/${version}";
    hash = "sha256-ALsSpygJlqYW/7Z44PZmBcIxfrtOPPrvuuMIOyFE5kE=";
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "dnspython"
    "pyopenssl"
    "requests"
    "tqdm"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    dnspython
    pyopenssl
    requests
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "knock" ];

  meta = with lib; {
    description = "Tool to scan subdomains";
    homepage = "https://github.com/guelfoweb/knock";
    changelog = "https://github.com/guelfoweb/knock/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "knockpy";
  };
}
