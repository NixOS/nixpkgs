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
}:

buildPythonPackage {
  pname = "wikitextprocessor";
  version = "0.4.96-unstable-2025-09-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tatuylonen";
    repo = "wikitextprocessor";
    fetchSubmodules = true;
    rev = "05d94841963c5b77c2977fd15e60f9c160d8071b";
    hash = "sha256-EhPYYN9uI5cLJFkklw8B1jOFMPe4KJMXhHoPHKK2E0o=";
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
    "test_process_dump" # It requires Internet
    "test_fetchlanguage"
    "test_language_parser_function"
  ];

  doCheck = true;

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
