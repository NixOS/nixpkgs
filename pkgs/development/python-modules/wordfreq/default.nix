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
  version = "2.3.2";
  disabled = pythonOlder "3";

   src = fetchFromGitHub {
    owner = "LuminosoInsight";
    repo = "wordfreq";
    # upstream don't tag by version
    rev = "v${version}";
    sha256 = "078657iiksrqzcc2wvwhiilf3xxq5vlinsv0kz03qzqr1qyvbmas";
   };

  propagatedBuildInputs = [ regex langcodes ftfy msgpack mecab-python3 jieba ];

  # patch to relax version requirements for regex
  # dependency to prevent break in upgrade
  postPatch = ''
    substituteInPlace setup.py --replace "regex ==" "regex >="
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    # These languages require additional dictionaries
    pytest tests -k 'not test_japanese and not test_korean and not test_languages and not test_french_and_related'
  '';

  meta = with lib; {
    description = "A library for looking up the frequencies of words in many languages, based on many sources of data";
    homepage =  "https://github.com/LuminosoInsight/wordfreq/";
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
