{ lib
, buildPythonPackage
, cairocffi
, cython
, fetchPypi
, igraph
, leidenalg
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
, scipy
, setuptools
, spacy
<<<<<<< HEAD
, spacy-lookups-data
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, en_core_web_sm
, toolz
, tqdm
, wasabi
}:

buildPythonPackage rec {
  pname = "textnets";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.8.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-fx2S43IqpSMsfJow26jB/D27dyUFQ1PlXP1rbUIZPPQ=";
=======
    hash = "sha256-rjXEiaPYctrONIZz1Dd5OSDw5z8D2FPXi5TneKizFUQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    cairocffi
    igraph
    leidenalg
    pandas
    scipy
    spacy
<<<<<<< HEAD
    spacy-lookups-data
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    toolz
    tqdm
    wasabi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    en_core_web_sm
  ];

  pythonImportsCheck = [
    "textnets"
  ];

  meta = with lib; {
    description = "Text analysis with networks";
    homepage = "https://textnets.readthedocs.io";
    changelog = "https://github.com/jboynyc/textnets/blob/v${version}/HISTORY.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jboy ];
  };
}
