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

  nativeBuildInputs = [
    setuptools
    pdm-backend
  ];

  propagatedBuildInputs = [
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
    "test_check_one_file_no_changes"
    "test_config_parsing"
    "test_corrects_code_from_stdin"
    "test_corrects_one_file"
    "test_corrects_three_files"
    "test_empty_list_inline_comment_indentation"
    "test_find_files"
    "test_fix_code_converts_non_valid_false_booleans"
    "test_ignores_correct_files"
    "test_include_exclude_files"
    "test_read_prefixed_environment_variables"
    "test_section_whitelines"
    "test_whitelines"
    "test_sequence_style_env_enum_parsing"
    "test_verbose_option"
    "test_enforcing_flow_style_together_with_adjustable_newlines"
  ];

  meta = with lib; {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koozz ];
  };
}
