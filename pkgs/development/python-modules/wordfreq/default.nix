{ lib
, buildPythonPackage
, regex
, langcodes
, ftfy
, msgpack
, mecab-python3
, jieba
, pytestCheckHook
, isPy27
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "wordfreq";
  version = "3.0.2";
  disabled = isPy27;

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    rev = "refs/tags/v${version}";
    hash = "sha256-ANOBbQWLB35Vz6oil6QZDpsNpKHeKUJnDKA5Q9JRVdE=";
   };

  propagatedBuildInputs = [
    regex
    langcodes
    ftfy
    msgpack
    mecab-python3
    jieba
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "regex ==" "regex >="
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    # These languages require additional dictionaries that aren't packaged
    "test_languages"
    "test_japanese"
    "test_korean"
  ];

  meta = with lib; {
    description = "A library for looking up the frequencies of words in many languages, based on many sources of data";
    homepage =  "https://github.com/LuminosoInsight/wordfreq/";
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
