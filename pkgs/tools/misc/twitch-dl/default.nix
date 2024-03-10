{ lib
, fetchFromGitHub
, python3Packages
, installShellFiles
, scdoc
}:

python3Packages.buildPythonApplication rec {
  pname = "twitch-dl";
  version = "2.1.4";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ihabunek";
    repo = "twitch-dl";
    rev = "refs/tags/${version}";
    hash = "sha256-0mITsNQQWG6lVQSxnDdU4ta548AR9q+zs/E96uwtG/U=";
  };

  nativeCheckInputs = [
    installShellFiles
    python3Packages.pytestCheckHook
    scdoc
  ];

  propagatedBuildInputs = with python3Packages; [
    httpx
    m3u8
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_api.py"
  ];

  pythonImportsCheck = [
    "twitchdl"
  ];

  postInstall = ''
    scdoc < twitch-dl.1.scd > twitch-dl.1
    installManPage twitch-dl.1
  '';

  meta = with lib; {
    description = "CLI tool for downloading videos from Twitch";
    homepage = "https://github.com/ihabunek/twitch-dl";
    changelog = "https://github.com/ihabunek/twitch-dl/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "twitch-dl";
  };
}
