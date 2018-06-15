{ lib
, buildPythonPackage
, regex
, langcodes
, ftfy
, msgpack
, mecab-python3
, jieba
, nose
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "wordfreq";
  version = "2.0";

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    rev = "e3a1b470d9f8e0d82e9f179ffc41abba434b823b";
    sha256 = "1wjkhhj7nxfnrghwvmvwc672s30lp4b7yr98gxdxgqcq6wdshxwv";
   };

  checkInputs = [ nose ];

  checkPhase = ''
    # These languages require additional dictionaries
    nosetests -e test_japanese -e test_korean -e test_languages
  '';
   
  propagatedBuildInputs = [ regex langcodes ftfy msgpack mecab-python3 jieba ];
  
  # patch to relax version requirements for regex
  # dependency to prevent break in upgrade
  postPatch = ''
    substituteInPlace setup.py --replace "regex ==" "regex >="
  '';
    
  disabled = pythonOlder "3";

  meta = with lib; {
    description = "A library for looking up the frequencies of words in many languages, based on many sources of data";
    homepage =  https://github.com/LuminosoInsight/wordfreq/;
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
