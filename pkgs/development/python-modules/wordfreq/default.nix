{
  lib,
  buildPythonPackage,
  poetry-core,
  regex,
  langcodes,
  locate,
  ftfy,
  msgpack,
  mecab-python3,
  jieba,
  pytestCheckHook,
  fetchFromGitHub,
}:

buildPythonPackage (finalAttrs: {
  pname = "wordfreq";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rspeer";
    repo = "wordfreq";
    # The v3.2 tag points to the preceding commit before the version bump.
    rev = "912caf64b657478d1dff1138efdc078947d54bb1";
    hash = "sha256-Ni93q6557jWTPYpqWCEriFmkJeYtMy9I5A8GLxJ7QfQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    regex
    langcodes
    locate
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

  meta = {
    description = "Library for looking up the frequencies of words in many languages, based on many sources of data";
    homepage = "https://github.com/rspeer/wordfreq/";
    changelog = "https://github.com/rspeer/wordfreq/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
})
