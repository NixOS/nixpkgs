{ stdenv
, fetchFromGitHub
, fetchpatch
, python3Packages
, glibcLocales
, coreutils
, git
}:

python3Packages.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.9.13";

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner  = "xonsh";
    repo   = "xonsh";
    rev    = "refs/tags/${version}";
    sha256 = "0nk6rjdkbxli510iwqspvray48kdxvbdmq1k8nxn14kqfpqzlbcv";
  };

  patches = [
    (fetchpatch {
      name = "fix-ptk-tests.patch";
      url = "https://github.com/xonsh/xonsh/commit/ca7acecc968dcda7dd56c1f5d5b4df349c98d734.patch";
      sha256 = "00nhbf9wzm6r86r9zq8mnhds30w6gdhkgsx5kpl0jppiz4ll96iw";
    })
  ];

  LC_ALL = "en_US.UTF-8";
  postPatch = ''
    sed -ie "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie "s|SHELL=xonsh|SHELL=$out/bin/xonsh|" tests/test_integrations.py

    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' tests/test_integrations.py
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' scripts/xon.sh
    find -name "*.xsh" | xargs sed -ie 's|/usr/bin/env|${coreutils}/bin/env|'
    patchShebangs .
  '';

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    HOME=$TMPDIR pytest -k 'not test_repath_backslash and not test_os and not test_man_completion and not test_builtins and not test_main and not test_ptk_highlight'
    HOME=$TMPDIR pytest -k 'test_builtins or test_main' --reruns 5
    HOME=$TMPDIR pytest -k 'test_ptk_highlight'
  '';

  checkInputs = [ python3Packages.pytest python3Packages.pytest-rerunfailures glibcLocales git ];

  propagatedBuildInputs = with python3Packages; [ ply prompt_toolkit pygments ];

  meta = with stdenv.lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = https://xon.sh/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ spwhitt vrthra ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/xonsh";
  };
}
