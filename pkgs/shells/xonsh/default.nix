{ lib
, fetchFromGitHub
, python3Packages
, glibcLocales
, coreutils
, git
}:

python3Packages.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.14.0";

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    rev = "refs/tags/${version}";
    sha256 = "sha256-ZrPKKa/vl06QAjGr16ZzKF/DAByFHr6ze2WVOCa+wf8=";
  };

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    sed -ie "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie "s|SHELL=xonsh|SHELL=$out/bin/xonsh|" tests/test_integrations.py

    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' tests/test_integrations.py
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' scripts/xon.sh
    find scripts -name 'xonsh*' -exec sed -i -e "s|env -S|env|" {} \;
    find -name "*.xsh" | xargs sed -ie 's|/usr/bin/env|${coreutils}/bin/env|'
    patchShebangs .

    substituteInPlace scripts/xon.sh \
      --replace 'python' "${python3Packages.python}/bin/python"

  '';

  makeWrapperArgs = [
    "--prefix PYTHONPATH : ${placeholder "out"}/lib/${python3Packages.python.libPrefix}/site-packages"
  ];

  disabledTests = [
    # fails on sandbox
    "test_colorize_file"
    "test_loading_correctly"
    "test_no_command_path_completion"
    "test_bsd_man_page_completions"
    "test_xonsh_activator"
    # fails on non-interactive shells
    "test_capture_always"
    "test_casting"
    "test_command_pipeline_capture"
    "test_dirty_working_directory"
    "test_man_completion"
    "test_vc_get_branch"
    "test_bash_and_is_alias_is_only_functional_alias"
  ];

  disabledTestPaths = [
    # fails on sandbox
    "tests/completers/test_command_completers.py"
    "tests/test_ptk_highlight.py"
    "tests/test_ptk_shell.py"
    # fails on non-interactive shells
    "tests/prompt/test_gitstatus.py"
    "tests/completers/test_bash_completer.py"
  ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  nativeCheckInputs = [ glibcLocales git ] ++
    (with python3Packages; [ pyte pytestCheckHook pytest-mock pytest-subprocess ]);

  propagatedBuildInputs = with python3Packages; [ ply prompt-toolkit pygments ];

  meta = with lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "https://xon.sh/";
    changelog = "https://github.com/xonsh/xonsh/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vrthra ];
  };

  passthru = {
    shellPath = "/bin/xonsh";
  };
}
