{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "creds";
  version = "0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ihebski";
    repo = "DefaultCreds-cheat-sheet";
    rev = "refs/tags/creds-${version}";
    hash = "sha256-s9ja2geFTnul7vUlGI4Am+IG3C0igICf0whnyd3SHdQ=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "tinydb==4.3" "tinydb" \
      --replace "pathlib" ""
    substituteInPlace creds \
      --replace "pathlib.Path(__file__).parent" "pathlib.Path.home()"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    fire
    prettytable
    requests
    tinydb
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool to search a collection of default credentials";
    homepage = "https://github.com/ihebski/DefaultCreds-cheat-sheet";
    changelog = "https://github.com/ihebski/DefaultCreds-cheat-sheet/releases/tag/creds-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
