{ lib
, fetchFromGitHub
, jadx
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "apkleaks";
  version = "2.6.2";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-a7zOowvhV9H91RwNDImN2+ecixY8g3WUotlBQVdmLgA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "apkleaks";
  };
}
