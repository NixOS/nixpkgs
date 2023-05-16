{ lib
, buildPythonPackage
<<<<<<< HEAD
, poetry-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, regex
, langcodes
, ftfy
, msgpack
, mecab-python3
, jieba
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
, isPy27
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "wordfreq";
  version = "3.0.2";
<<<<<<< HEAD
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rspeer";
    repo = "wordfreq";
    rev = "refs/tags/v${version}";
    hash = "sha256-ANOBbQWLB35Vz6oil6QZDpsNpKHeKUJnDKA5Q9JRVdE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
=======
  disabled = isPy27;

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    rev = "refs/tags/v${version}";
    hash = "sha256-ANOBbQWLB35Vz6oil6QZDpsNpKHeKUJnDKA5Q9JRVdE=";
   };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    regex
    langcodes
    ftfy
    msgpack
    mecab-python3
    jieba
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace setup.py --replace "regex ==" "regex >="
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    # These languages require additional dictionaries that aren't packaged
    "test_languages"
    "test_japanese"
    "test_korean"
  ];

  meta = with lib; {
    description = "A library for looking up the frequencies of words in many languages, based on many sources of data";
<<<<<<< HEAD
    homepage =  "https://github.com/rspeer/wordfreq/";
=======
    homepage =  "https://github.com/LuminosoInsight/wordfreq/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
