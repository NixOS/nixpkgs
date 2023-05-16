{ lib
, fetchFromGitHub
<<<<<<< HEAD
, python3
=======
, python3Packages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, glibcLocales
, coreutils
, git
}:

<<<<<<< HEAD
python3.pkgs.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.14.0";
  format = "pyproject";
=======
python3Packages.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.13.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-ZrPKKa/vl06QAjGr16ZzKF/DAByFHr6ze2WVOCa+wf8=";
  };

  env.LC_ALL = "en_US.UTF-8";
=======
    sha256 = "sha256-/u8jA7sLy3N8483uIzqBeSxEAGhX7+XS4D14n+15JHU=";
  };

  LC_ALL = "en_US.UTF-8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    sed -ie "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie "s|SHELL=xonsh|SHELL=$out/bin/xonsh|" tests/test_integrations.py

    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' tests/test_integrations.py
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' scripts/xon.sh
    find scripts -name 'xonsh*' -exec sed -i -e "s|env -S|env|" {} \;
    find -name "*.xsh" | xargs sed -ie 's|/usr/bin/env|${coreutils}/bin/env|'
    patchShebangs .
<<<<<<< HEAD
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

=======

    substituteInPlace scripts/xon.sh \
      --replace 'python' "${python3Packages.python}/bin/python"

  '';

  makeWrapperArgs = [
    "--prefix PYTHONPATH : ${placeholder "out"}/lib/${python3Packages.python.libPrefix}/site-packages"
  ];

  postInstall = ''
    wrapProgram $out/bin/xonsh \
      $makeWrapperArgs
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    (with python3.pkgs; [ pip pyte pytestCheckHook pytest-mock pytest-subprocess ]);

  propagatedBuildInputs = with python3.pkgs; [ ply prompt-toolkit pygments ];
=======
    (with python3Packages; [ pyte pytestCheckHook pytest-mock pytest-subprocess ]);

  propagatedBuildInputs = with python3Packages; [ ply prompt-toolkit pygments ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "https://xon.sh/";
    changelog = "https://github.com/xonsh/xonsh/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vrthra ];
  };

  passthru = {
    shellPath = "/bin/xonsh";
<<<<<<< HEAD
    python = python3;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
