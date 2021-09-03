{ lib, git, openssl, makeWrapper, buildPythonApplication, pytestCheckHook, ps
, fetchPypi, fetchFromGitLab }:

buildPythonApplication rec {
  pname = "pmbootstrap";
  version = "1.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uHN3nplQOMuBeQIxAocCVqwnmJUQZL67+iXLhQ7onps=";
  };

  repo = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "postmarketOS";
    repo = pname;
    rev = version;
    sha256 = "sha256-JunI/mqq+UvmzNVt3mdJN3+tKGN4uTrxkUU2imCNCNY=";
  };

  pmb_test = "${repo}/test";

  checkInputs = [ pytestCheckHook git openssl ps ];

  # Add test dependency in PATH
  checkPhase = "export PYTHONPATH=$PYTHONPATH:${pmb_test}";

  # skip impure tests
  disabledTests = [
    "test_get_apkbuild"
    "test_check_build_for_arch"
    "test_get_depends"
    "test_build_depends_no_binary_error"
    "test_build_depends_binary_outdated"
    "test_init_buildenv"
    "test_run_abuild"
    "test_finish"
    "test_package"
    "test_build_depends_high_level"
    "test_build_local_source_high_level"
    "test_chroot_interactive_shell"
    "test_chroot_interactive_shell_user"
    "test_chroot_arguments"
    "test_switch_to_channel_branch"
    "test_read_config_channel"
    "test_cross_compile_distcc"
    "test_build_src_invalid_path"
    "test_can_fast_forward"
    "test_clean_worktree"
    "test_get_upstream_remote"
    "test_pull"
    "test_helpers_package_get_apkindex"
    "test_filter_missing_packages_invalid"
    "test_filter_missing_packages_binary_exists"
    "test_filter_missing_packages_pmaports"
    "test_filter_aport_packages"
    "test_pmbootstrap_status"
    "test_print_checks_git_repo"
    "test_helpers_ui"
    "test_newapkbuild"
    "test_package_from_aports"
    "test_recurse_invalid"
    "test_questions_bootimg"
    "test_questions_keymaps"
    "test_questions_work_path"
    "test_questions_channel"
    "test_apk_static"
    "test_aportgen"
    "test_aportgen_device_wizard"
    "test_bootimg"
    "test_build_is_necessary"
    "test_config_user"
    "test_crossdirect"
    "test_file"
    "test_folder_size"
    "test_helpers_lint"
    "test_helpers_repo"
    "test_kconfig_check"
    "test_keys"
    "test_pkgrel_bump"
    "test_qemu_running_processes"
    "test_run_core"
    "test_shell_escape"
    "test_version"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ git openssl ]}" ];

  meta = with lib; {
    description = "Sophisticated chroot/build/flash tool to develop and install postmarketOS";
    homepage = "https://gitlab.com/postmarketOS/pmbootstrap";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ payas ];
  };
}
