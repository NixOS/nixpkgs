{
  lib,
  buildPythonPackage,
  poetry-core,
  regex,
  langcodes,
  ftfy,
  msgpack,
  mecab-python3,
  jieba,
  pytestCheckHook,
  pythonOlder,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "wordfreq";
  version = "3.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rspeer";
    repo = "wordfreq";
    rev = "refs/tags/v${version}";
    hash = "sha256-ANOBbQWLB35Vz6oil6QZDpsNpKHeKUJnDKA5Q9JRVdE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    regex
    langcodes
    ftfy
    msgpack
    mecab-python3
    jieba
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    # These languages require additional dictionaries that aren't packaged
    "test_languages"
    "test_japanese"
    "test_korean"
  ];

  meta = with lib; {
    description = "A library for looking up the frequencies of words in many languages, based on many sources of data";
    homepage = "https://github.com/rspeer/wordfreq/";
    license = licenses.mit;
  };
}
