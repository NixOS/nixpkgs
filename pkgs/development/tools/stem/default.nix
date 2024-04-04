{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "stem";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "torproject";
    repo = "stem";
    rev = version;
    hash = "sha256-9BXeE/sVa13jr8G060aWjc49zgDVBhjaR6nt4lSxc0g=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  meta = with lib; {
    description = "Stem is a Python controller library for Tor";
    homepage = "https://stem.torproject.org/";
    license = with licenses.gpl3Only;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "tor-prompt";
  };
}
