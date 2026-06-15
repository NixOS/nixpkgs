{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # nativeBuildInputs
  makeWrapper,

  # dependencies
  crytic-compile,
  packaging,
  prettytable,
  web3,

  # tests
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,

  # test dependencies
  deepdiff,
  filelock,
  numpy,
  pytest-insta,
  pytest-xdist,
  vyper,

  # postFixup
  solc,

  withSolc ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "slither-analyzer";
  version = "0.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "slither";
    tag = finalAttrs.version;
    hash = "sha256-sy1vE9XniwyvvZRFnnKhPfmYh2auHHcMel9sZx2YK3c=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = [
    crytic-compile
    packaging
    prettytable
    web3
  ];

  pythonRelaxDeps = [
    "crytic-compile"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook

    deepdiff
    filelock
    numpy
    pytest-insta
    pytest-xdist
    vyper
  ];

  versionCheckKeepEnvironment = [ "HOME" ];

  postFixup = lib.optionalString withSolc ''
    wrapProgram $out/bin/slither \
      --prefix PATH : "${lib.makeBinPath [ solc ]}"
  '';

  disabledTests = [
    # Require network
    "test_abstract_contract"
    "test_arithmetic_usage"
    "test_backup_source_file"
    "test_concrete_contract"
    "test_constant_folding_binary_expressions"
    "test_constant_folding_rational"
    "test_constant_folding_unary"
    "test_contract_comments"
    "test_contract_function_parameter"
    "test_contract_name_collision"
    "test_custom_storage_layout"
    "test_cycle"
    "test_enum_max_min"
    "test_fallback_receive"
    "test_find_variable_scope_with_renaming"
    "test_function_can_send_eth"
    "test_function_id_rec_structure"
    "test_functions"
    "test_functions_ids"
    "test_inheritance_printer"
    "test_inheritance_with_duplicate_names"
    "test_inheritance_with_renaming"
    "test_interface_generation"
    "test_internal_call_reorder"
    "test_issue_1846_ternary_in_ternary[False]"
    "test_issue_1846_ternary_in_ternary[True]"
    "test_local_alias"
    "test_name_resolution_compact"
    "test_name_resolution_legacy_post_0_5_0"
    "test_name_resolution_legacy_pre_0_5_0"
    "test_nested_ifs_with_loop_compact"
    "test_nested_ifs_with_loop_legacy"
    "test_operation_reads"
    "test_overridden_function_reorder"
    "test_overrides"
    "test_parameter_no_library"
    "test_private_variable"
    "test_public_variable"
    "test_reentrant"
    "test_references_user_defined_aliases"
    "test_references_user_defined_types_when_casting"
    "test_return_multiple_with_struct[False]"
    "test_return_multiple_with_struct[True]"
    "test_scope_is_checked"
    "test_should_mutate_function_includes_modifier"
    "test_should_mutate_function_matching_selector"
    "test_should_mutate_function_no_filter"
    "test_should_mutate_function_no_match"
    "test_slithir_printer"
    "test_source_mapping_inheritance[0.6.12]"
    "test_source_mapping_inheritance[0.8.7]"
    "test_source_mapping_inheritance[0.8.8]"
    "test_source_mapping_top_level_defs"
    "test_storage_layout"
    "test_struct_constructor_reorder"
    "test_ternary_conversions"
    "test_ternary_tuple"
    "test_top_level_using_for"
    "test_tuple_order"
    "test_tuple_reassign"
    "test_upgradeable_comments"
    "test_upgrades_compare"
    "test_upgrades_implementation_var"
    "test_using_for_alias_contract"
    "test_using_for_alias_top_level"
    "test_using_for_constant_folding"
    "test_using_for_global_collision"
    "test_using_for_in_library"
    "test_using_for_top_level_implicit_conversion"
    "test_using_for_top_level_same_name"
    "test_virtual_is_implemented"
    "test_virtual_override_references_and_implementations"
    "test_with_explicit_return[False]"
    "test_with_explicit_return[True]"
    "test_yul_parser_assembly_slot"
    "test_yul_parser_sstore_sload"

    # Require ganache which isn't in nixpkgs
    "test_read_storage[StorageLayout-storage_layout]"
    "test_read_storage[UnstructuredStorageLayout-unstructured_storage]"

    # Triggers https://github.com/crytic/slither/issues/2796
    "test_phi_entry_point_internal_call"
    "test_call_with_default_args"

    # Doesn't work with vyper >= 0.4.0
    "test_vyper_functions"

    # ERROR:CryticCompile:Constructor must be marked as `@deploy`
    "test_references_self_identifier"

    #ERROR:CryticCompile:Calls to external nonpayable functions must use the `extcall` keyword.
    "test_interface_conversion_and_call_resolution"
  ];

  disabledTestPaths = [
    # Errors with ConnectionError
    "tests/unit/slithir/test_ssa_generation.py"

    # Triggers https://github.com/crytic/slither/issues/2796
    "tests/e2e/vyper_parsing/test_ast_parsing.py"
  ];

  pythonImportsCheck = [
    "slither"
    "slither.all_exceptions"
    "slither.analyses"
    "slither.core"
    "slither.detectors"
    "slither.exceptions"
    "slither.formatters"
    "slither.printers"
    "slither.slither"
    "slither.slithir"
    "slither.solc_parsing"
    "slither.utils"
    "slither.visitors"
    "slither.vyper_parsing"
  ];

  meta = {
    description = "Static Analyzer for Solidity";
    longDescription = ''
      Slither is a Solidity static analysis framework written in Python 3. It
      runs a suite of vulnerability detectors, prints visual information about
      contract details, and provides an API to easily write custom analyses.
    '';
    homepage = "https://github.com/trailofbits/slither";
    changelog = "https://github.com/crytic/slither/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "slither";
    maintainers = with lib.maintainers; [
      arturcygan
      fab
      hellwolf
    ];
  };
})
