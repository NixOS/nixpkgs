{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  rustworkx,
  tree-sitter,
  tree-sitter-language-pack,
  hypothesis,
  mutmut,
  pytest,
  pytest-cov,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "trailmark";
  version = "0.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "trailmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e+IcCiILDBJNaLjkBl+i7NVcYp5r8/7KrR6dFvK0NwM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    rustworkx
    tree-sitter
    tree-sitter-language-pack
  ];

  pythonImportsCheck = [ "trailmark" ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  checkInputs = [
    hypothesis
    mutmut
    pytest
    pytest-cov
  ];

  disabledTests = [
    # searches git via shutil
    "test_worktree_materializes_a_ref"
    # fail with requires networking
    "test_single_language_directory"
    "test_multiple_languages_in_one_dir"
    "test_skips_vendor_directories"
    "test_detects_modern_javascript_module_extensions"
    "test_auto_detects_and_merges"
    "test_auto_merges_entrypoints"
    "test_auto_parses_mjs_files_into_nodes"
  ];

  versionCheckProgram = "${placeholder "out"}/bin/trailmark";

  meta = {
    homepage = "https://github.com/trailofbits/trailmark/";
    description = "Build and query a graph database representation of source code";
    changelog = "https://github.com/trailofbits/trailmark/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "bw";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ wamserma ];
  };
})
