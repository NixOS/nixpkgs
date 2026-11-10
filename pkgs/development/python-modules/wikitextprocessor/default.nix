{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dateparser,
  lupa,
  lxml,
  mediawiki-langcodes,
  psutil,
  requests,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "wikitextprocessor";
  version = "0.4.96-unstable-2026-03-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tatuylonen";
    repo = "wikitextprocessor";
    fetchSubmodules = true;
    rev = "9d9a410c45c06d30239bcc0d8c1a57718a3f7a2c";
    hash = "sha256-qhl9yRF2MUQvKXgcuxu20h6cEQofN1xMMb4JJZcFHS0=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "dateparser" ];

  dependencies = [
    dateparser
    lupa
    lxml
    mediawiki-langcodes
    psutil
    requests
  ];

  pythonImportsCheck = [ "wikitextprocessor" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # It requires Internet
    "test_process_dump"
    # It attempts to write a readonly database
    "test_fetchlanguage"
    "test_language_parser_function"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Parser and expander for Wikipedia, Wiktionary etc. dump files, with Lua execution support";
    homepage = "https://github.com/tatuylonen/wikitextprocessor";
    license = with lib.licenses; [
      mit
      cc-by-sa-40 # Needed for certain test files under Wiktionary licence
      gpl2Plus # Needed for certain files in lua/mediawiki-extensions-Scribunto/
    ];
    maintainers = with lib.maintainers; [ theobori ];
  };
}
