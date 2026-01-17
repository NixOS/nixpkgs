{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  babelfish,
  beautifulsoup4,
  chardet,
  click,
  click-option-group,
  defusedxml,
  dogpile-cache,
  enzyme,
  guessit,
  knowit,
  srt,
  pysubs2,
  rarfile,
  requests,
  platformdirs,
  stevedore,
  tomli,
  tomlkit,

  # nativeCheckInputs
  colorama,
  pypandoc,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  mypy,
  sympy,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "subliminal";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Diaoul";
    repo = "subliminal";
    tag = version;
    hash = "sha256-dA+UoSzMjncF619yfvRnXJFBrVi9FCkuqeN0X7FGiv8=";
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
    pypandoc
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
    "integration"
    "test_cli_cache"
    "test_cli_download"
    "test_is_supported_archive"
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
