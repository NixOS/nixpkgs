{
  lib,
  fetchFromGitHub,
  jadx,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apkleaks";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = "apkleaks";
    rev = "refs/tags/v${version}";
    hash = "sha256-a7zOowvhV9H91RwNDImN2+ecixY8g3WUotlBQVdmLgA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    jadx
    pyaxmlparser
    setuptools
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "apkleaks" ];

  meta = with lib; {
    description = "Scanning APK file for URIs, endpoints and secrets";
    homepage = "https://github.com/dwisiswant0/apkleaks";
    changelog = "https://github.com/dwisiswant0/apkleaks/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "apkleaks";
  };
}
