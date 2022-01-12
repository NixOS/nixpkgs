{ lib, python3, fetchFromGitHub }:
let
  python = python3.override {
    # override resolvelib due to
    # 1. pdm requiring a later version of resolvelib
    # 2. Ansible being packaged as a library
    # 3. Ansible being unable to upgrade to a later version of resolvelib
    # see here for more details: https://github.com/NixOS/nixpkgs/pull/155380/files#r786255738
    packageOverrides = self: super: {
      resolvelib = super.resolvelib.overridePythonAttrs (attrs: rec {
        version = "0.8.1";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = version;
          sha256 = "sha256-QDHEdVET7HN2ZCKxNUMofabR+rxJy0erWhNQn94D7eI=";
        };
      });
    };
    self = python;
  };
in

with python.pkgs;
buildPythonApplication rec {
  pname = "pdm";
  version = "1.12.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MXKER2ijU+2yPnsBFH0cu/hjHI4uNt++AqggH5rhnaU=";
  };

  # this patch allows us to run additional tests that invoke pdm, which checks
  # itself for an update on every invocation by default, drammatically slowing
  # down test runs inside the sandbox
  #
  # the patch is necessary because the fixture is creating a project and
  # doesn't appear to respect the settings in `$HOME`; possibly a bug upstream
  patches = [ ./check-update.patch ];

  propagatedBuildInputs = [
    blinker
    click
    installer
    packaging
    pdm-pep517
    pep517
    pip
    platformdirs
    python-dotenv
    pythonfinder
    resolvelib
    shellingham
    tomli
    tomlkit
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  preCheck = "HOME=$TMPDIR";

  disabledTests = [
    # these may eventually succeed but are incredibly slow due to contacting
    # the internet
    "test_convert_requirements_file_without_name"
    "test_add_dependency_from_multiple_parents"
    "test_add_editable_package"
    "test_add_package"
    "test_add_package_with_mismatch_marker"
    "test_add_with_dry_run"
    "test_add_with_prerelease"
    "test_build_src_package_by_include"
    "test_editable_package_override_non_editable"
    "test_find_candidates_from_find_links"
    "test_freeze_dependencies_list"
    "test_info_global_project"
    "test_install_with_dry_run"
    "test_install_with_lockfile"
    "test_list_dependency_graph"
    "test_list_dependency_graph_with_circular_forward"
    "test_list_dependency_graph_with_circular_reverse"
    "test_list_reverse_dependency_graph"
    "test_load_multiple_plugings"
    "test_old_entry_point_compatibility"
    "test_parse_flit_project_metadata"
    "test_parse_local_directory_metadata"
    "test_parse_project_file_on_build_error"
    "test_parse_project_file_on_build_error_no_dep"
    "test_parse_project_file_on_build_error_with_extras"
    "test_parse_vcs_metadata"
    "test_post_lock_and_install_signals"
    "test_remove_both_normal_and_editable_packages"
    "test_remove_package"
    "test_remove_package_exist_in_multi_groups"
    "test_remove_package_no_sync"
    "test_remove_package_not_exist"
    "test_remove_package_with_dry_run"
    "test_resolve_file_req_with_prerelease"
    "test_resolve_local_and_named_requirement"
    "test_resolve_two_extras_from_the_same_package"
    "test_resolve_vcs_and_local_requirements"
    "test_sync_clean_packages"
    "test_sync_dry_run"
    "test_sync_packages_with_group_all"
    "test_sync_packages_with_groups"
    "test_sync_production_packages"
    "test_update_all_packages"
    "test_update_dry_run"
    "test_update_existing_package_with_prerelease"
    "test_update_ignore_constraints"
    "test_update_packages_with_top"
    "test_update_top_packages_dry_run"
    "test_update_with_package_and_groups_argument"
    # requires the internet
    "test_actual_list_freeze"
    "test_add_cached_vcs_requirement"
    "test_add_remote_package_url"
    "test_basic_integration"
    "test_build_distributions"
    "test_build_ignoring_pip_environment"
    "test_build_legacy_package"
    "test_build_package"
    "test_build_package_include"
    "test_build_single_module"
    "test_build_single_module_with_readme"
    "test_build_src_package"
    "test_build_with_config_settings"
    "test_build_with_no_isolation"
    "test_cache_egg_info_sdist"
    "test_cache_vcs_immutable_revision"
    "test_cli_build_with_config_settings"
    "test_expand_project_root_in_url"
    "test_extras_warning"
    "test_hash_cache"
    "test_install_wheel_with_cache"
    "test_install_wheel_with_data_scripts"
    "test_install_wheel_with_inconsistent_dist_info"
    "test_install_with_file_existing"
    "test_parse_abnormal_specifiers"
    "test_parse_artifact_metadata"
    "test_parse_metadata_with_extras"
    "test_parse_remote_link_metadata"
    "test_pep582_launcher_for_python_interpreter"
    "test_rollback_after_commit"
    "test_run_with_another_project_root"
    "test_search_package"
    "test_show_update_hint"
    "test_sync_only_different"
    "test_sync_with_index_change"
    "test_uninstall_commit_rollback"
    "test_uninstall_with_console_scripts"
    "test_update_with_prerelease_without_package_argument"
    "test_url_requirement_is_not_cached"
    # sys.executable and expected executable are different
    "test_set_non_exist_python_path"
    # editable inside nixpkgs doesn't seem to be a thing
    "test_vcs_candidate_in_subdirectory"
    # pdm compares with what looks to be an older version of poetry
    "test_parse_poetry_project_metadata"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_auto_isolate_site_packages"
    "test_use_invalid_wrapper_python"
    "test_use_wrapper_python"
    # broken but wouldn't succeed anyway because of the network
    "test_sync_in_sequential_mode"
    # tries to read/write files without proper permissions
    "test_completion_command"
    "test_plugin_add"
    "test_plugin_list"
    "test_plugin_remove"
    # unknown breakage, but probably hitting the internet
    "test_show_package_on_pypi"
    # tries to treat a gzip file as a zipfile and fails
    "test_resolve_local_artifacts"
  ];

  meta = with lib; {
    homepage = "https://pdm.fming.dev";
    description = "A modern Python package manager with PEP 582 support";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
