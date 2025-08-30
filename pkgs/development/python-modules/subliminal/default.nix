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
  colorama,
  defusedxml,
  dogpile-cache,
  enzyme,
  guessit,
  hatch-vcs,
  hatchling,
  knowit,
  platformdirs,
  pypandoc,
  pysubs2,
  rarfile,
  requests,
  srt,
  stevedore,
  tomli,
  tomlkit,

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

  build-system = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    babelfish
    beautifulsoup4
    chardet
    click
    click-option-group
    defusedxml
    dogpile-cache
    enzyme
    guessit
    knowit
    srt
    pysubs2
    rarfile
    requests
    platformdirs
    stevedore
    tomli
    tomlkit
  ];

  nativeCheckInputs = [
    colorama
    mypy
    pypandoc
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    sympy
    vcrpy
  ];

  pythonImportsCheck = [ "subliminal" ];

  disabledTests = [
    # Tests require network access
    "integration"
    "test_cli_cache"
    "test_cli_download"
    "test_hash"
    "test_is_supported_archive"
    "test_refine"
    "test_scan"
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
