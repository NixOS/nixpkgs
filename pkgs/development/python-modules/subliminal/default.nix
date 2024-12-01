{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  babelfish,
  beautifulsoup4,
  chardet,
  click,
  click-option-group,
  dogpile-cache,
  enzyme,
  guessit,
  srt,
  pysubs2,
  rarfile,
  requests,
  platformdirs,
  stevedore,
  tomli,

  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  mypy,
  sympy,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "subliminal";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Diaoul";
    repo = "subliminal";
    rev = "refs/tags/${version}";
    hash = "sha256-g7gg2qdLKl7bg/nNXRWN9wZaNShOOc38sVASZrIycMU=";
  };

  propagatedBuildInputs = [
    babelfish
    beautifulsoup4
    chardet
    click
    click-option-group
    dogpile-cache
    enzyme
    guessit
    srt
    pysubs2
    rarfile
    requests
    platformdirs
    stevedore
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
    mypy
    sympy
    vcrpy
  ];

  pythonImportsCheck = [ "subliminal" ];

  disabledTests = [
    # Tests require network access
    "test_refine"
    "test_scan"
    "test_hash"
  ];

  meta = {
    description = "Python library to search and download subtitles";
    homepage = "https://github.com/Diaoul/subliminal";
    changelog = "https://github.com/Diaoul/subliminal/blob/${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
