{
  lib,
  appdirs,
  babelfish,
  beautifulsoup4,
  buildPythonPackage,
  chardet,
  click,
  dogpile-cache,
  enzyme,
  fetchFromGitHub,
  guessit,
  pysrt,
  pytestCheckHook,
  pythonOlder,
  pytz,
  rarfile,
  requests,
  six,
  stevedore,
  sympy,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "subliminal";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Diaoul";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-P4gVxKKCGKS3MC4F3yTAaOSv36TtdoYfrf61tBHg8VY=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --pep8 --flakes" ""
  '';

  propagatedBuildInputs = [
    appdirs
    babelfish
    beautifulsoup4
    chardet
    click
    dogpile-cache
    enzyme
    guessit
    pysrt
    pytz
    rarfile
    requests
    six
    stevedore
  ];

  nativeCheckInputs = [
    sympy
    vcrpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "subliminal" ];

  disabledTests = [
    # Tests rewuire network access
    "test_refine_video_metadata"
    "test_scan"
    "test_hash"
    "test_provider_pool_list_subtitles"
    "test_async_provider_pool_list_subtitles"
    "test_list_subtitles"
    "test_download_bad_subtitle"
    # Not implemented
    "test_save_subtitles"
  ];

  disabledTestPaths = [
    # AttributeError: module 'rarfile' has no attribute 'custom_check'
    "tests/test_legendastv.py"
  ];

  meta = with lib; {
    description = "Python library to search and download subtitles";
    homepage = "https://github.com/Diaoul/subliminal";
    changelog = "https://github.com/Diaoul/subliminal/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    # Too many tests fail ever since a certain python-updates merge, see:
    # https://github.com/Diaoul/subliminal/issues/1062 . Disabling tests
    # alltogether may produce a not completly failing executable, but that
    # executable apparently isn't able to download subtitles at all.
    broken = true;
  };
}
