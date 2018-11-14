{ lib
, buildPythonPackage
, regex
, langcodes
, ftfy
, msgpack
, mecab-python3
, jieba
, pytest
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "wordfreq";
  version = "2.2.0";

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    # upstream don't tag by version
    rev = "bc12599010c8181a725ec97d0b3990758a48da36";
    sha256 = "195794vkzq5wsq3mg1dgfhlnz2f7vi1xajlifq6wkg4lzwyq262m";
   };

  checkInputs = [ pytest ];

  checkPhase = ''
    # These languages require additional dictionaries
    pytest tests -k 'not test_japanese and not test_korean and not test_languages and not test_french_and_related'
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
