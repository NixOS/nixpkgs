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
  setuptools,
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
  version = "2.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Diaoul";
    repo = "subliminal";
    tag = version;
    hash = "sha256-eAXzD6diep28wCZjWLOZpOX1bnakEldhs2LX5CPu5OI=";
  };

  build-system = [ setuptools ];

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
    mainProgram = "subliminal";
    homepage = "https://github.com/Diaoul/subliminal";
    changelog = "https://github.com/Diaoul/subliminal/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
