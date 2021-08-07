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
  version = "2.5";
  disabled = isPy27;

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    rev = "v${version}";
    sha256 = "09wzraddbdw3781pk2sxlz8knax9jrcl24ymz54wx6sk0gvq95i7";
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
