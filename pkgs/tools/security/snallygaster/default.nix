{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "snallygaster";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "hannob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JXuRCUWpoGhBbU38XMEQovCiVfbyBMJ+SIrt3iqFuAo=";
  };

  propagatedBuildInputs = with python3Packages; [
    urllib3
    beautifulsoup4
    dnspython
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # we are not interested in linting the project
    "--ignore=tests/test_codingstyle.py"
  ];

  meta = with lib; {
    description = "Tool to scan for secret files on HTTP servers";
    mainProgram = "snallygaster";
    homepage = "https://github.com/hannob/snallygaster";
    license = licenses.cc0;
    maintainers = with maintainers; [ ];
  };
}
