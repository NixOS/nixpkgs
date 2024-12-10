{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "octosuite";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bellingcat";
    repo = "octosuite";
    rev = "refs/tags/${version}";
    hash = "sha256-C73txVtyWTcIrJSApBy4uIKDcuUq0HZrGM6dqDVLkKY=";
  };

  postPatch = ''
    # pyreadline3 is Windows-only
    substituteInPlace setup.py \
      --replace ', "pyreadline3"' ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    psutil
    requests
    rich
  ];

  pythonImportsCheck = [
    "octosuite"
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Advanced Github OSINT framework";
    mainProgram = "octosuite";
    homepage = "https://github.com/bellingcat/octosuite";
    changelog = "https://github.com/bellingcat/octosuite/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
