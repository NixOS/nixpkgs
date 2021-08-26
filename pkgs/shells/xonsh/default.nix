{ lib
, fetchFromGitHub
, python3Packages
, glibcLocales
, coreutils
, git
}:

python3Packages.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.10.1";

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xonsh";
    rev = version;
    sha256 = "03ahay2rl98a9k4pqkxksmj6mcg554jnbhw9jh8cyvjrygrpcpch";
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

  postInstall = ''
    wrapProgram $out/bin/xon.sh \
      $makeWrapperArgs
  '';

  disabledTests = [
    # fails on sandbox
    "test_colorize_file"
    "test_loading_correctly"
    "test_no_command_path_completion"
    # fails on non-interactive shells
    "test_capture_always"
    "test_casting"
    "test_command_pipeline_capture"
    "test_dirty_working_directory"
    "test_man_completion"
    "test_vc_get_branch"
  ];

  disabledTestPaths = [
    # fails on non-interactive shells
    "tests/prompt/test_gitstatus.py"
    "tests/completers/test_bash_completer.py"
  ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  checkInputs = [ glibcLocales git ] ++ (with python3Packages; [ pytestCheckHook pytest-subprocess ]);

  propagatedBuildInputs = with python3Packages; [ ply prompt-toolkit pygments ];

  meta = with lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "https://xon.sh/";
    changelog = "https://github.com/xonsh/xonsh/raw/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ spwhitt vrthra ];
  };

  passthru = {
    shellPath = "/bin/xonsh";
  };
}
