{ lib
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "quark-engine";
<<<<<<< HEAD
  version = "23.8.1";
=======
  version = "23.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-sdhTrRh6xkkIDZDGE22hSr5dD179VWdMVs6L1cJ9yiw=";
=======
    sha256 = "sha256-YOI768QNAgqUy3Vc2kyJCUeJE7j0PyP5BOUelhvyHgU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    androguard
    click
    colorama
    gitMinimal
    graphviz
    pandas
    plotly
    prettytable
    prompt-toolkit
    rzpipe
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "quark"
  ];

  meta = with lib; {
    description = "Android malware (analysis and scoring) system";
    homepage = "https://quark-engine.readthedocs.io/";
    changelog = "https://github.com/quark-engine/quark-engine/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
