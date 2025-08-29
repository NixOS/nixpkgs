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
  defusedxml,
  dogpile-cache,
  guessit,
  knowit,
  platformdirs,
  pysubs2,
  requests,
  srt,
  tomlkit,

  hatchling,
  hatch-vcs,

  colorama,
  pypandoc,
  pytestCheckHook,
  pytest-xdist,
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
    guessit
    knowit
    platformdirs
    pysubs2
    requests
    srt
    tomlkit
  ];

  nativeCheckInputs = [
    colorama
    pypandoc
    pytestCheckHook
    pytest-xdist
    sympy
    vcrpy
  ];

  pythonImportsCheck = [ "subliminal" ];

  disabledTests = [
    # Tests require network access
    "cli_cache"
    "cli_download"
    "opensubtitles"
    "test_archives"
    "test_hash"
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
