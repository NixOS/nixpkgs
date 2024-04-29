{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, maison
, pdm-backend
, pytest-freezegun
, pytest-xdist
, pytestCheckHook
, pythonOlder
, ruyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.16.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    rev = "refs/tags/${version}";
    hash = "sha256-nadyBIzXHbWm0QvympRaYU38tuPJ3TPJg8EbvVv+4L0=";
  };

  build-system = [
    setuptools
    pdm-backend
  ];

  dependencies = [
    click
    maison
    ruyaml
  ];

  nativeCheckInputs = [
    pytest-freezegun
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "yamlfix"
  ];

  disabledTests = [
    # AssertionError: assert ... Fixed <stdin> in...
    "test_anchors_and_aliases_with_duplicate_merge_keys"
    "test_check_one_file_no_changes"
    "test_config_parsing"
    "test_corrects_code_from_stdin"
    "test_corrects_one_file"
    "test_corrects_three_files"
    "test_empty_list_inline_comment_indentation"
    "test_enforcing_flow_style_together_with_adjustable_newlines"
    "test_find_files"
    "test_fix_code_adds_header"
    "test_fix_code_converts_non_valid_false_booleans"
    "test_fix_code_corrects_indentation_on_lists"
    "test_fix_code_doesnt_change_double_exclamation_marks"
    "test_fix_code_doesnt_double_the_header"
    "test_fix_code_functions_emit_debug_logs"
    "test_fix_code_parses_files_with_multiple_documents"
    "test_fix_code_preserves_indented_comments"
    "test_fix_code_respects_apostrophes_for_truthy_substitutions"
    "test_fix_files_can_process_string_arguments"
    "test_ignores_correct_files"
    "test_include_exclude_files"
    "test_quote_values_config_and_preserve_quotes"
    "test_read_prefixed_environment_variables"
    "test_section_whitelines"
    "test_sequence_block_style_config"
    "test_sequence_keep_style_config"
    "test_sequence_block_style_enforcement_for_lists_with_comments"
    "test_sequence_style_env_enum_parsing"
    "test_verbose_option"
    "test_whitelines"
  ];

  meta = with lib; {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koozz ];
  };
}
