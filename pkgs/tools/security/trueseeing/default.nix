{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
<<<<<<< HEAD
  version = "2.1.7";
=======
  version = "2.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "flit";

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-pnIn+Rqun5J3F9cgeBUBX4e9WP5fgbm+vwN3Wqh/yEc=";
=======
    rev = "v${version}";
    hash = "sha256-7iQOQ81k2bPBber4ewyvDy82s26j4P3Vv8MzSs04KAw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = with python3.pkgs; [
    flit-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    ipython
    jinja2
    lxml
    pypubsub
    pyyaml
    docker
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "attrs~=21.4" "attrs>=21.4" \
      --replace "docker~=5.0.3" "docker"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "trueseeing"
  ];

  meta = with lib; {
    description = "Non-decompiling Android vulnerability scanner";
    homepage = "https://github.com/alterakey/trueseeing";
<<<<<<< HEAD
    changelog = "https://github.com/alterakey/trueseeing/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
