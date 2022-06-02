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
  version = "2.5.1";
  disabled = isPy27;

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    rev = "v${version}";
    sha256 = "1lw7kbsydd89hybassnnhqnj9s5ch9wvgd6pla96198nrq9mj7fw";
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

  checkInputs = [ pytestCheckHook ];
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
