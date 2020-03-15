{ stdenv
, fetchFromGitHub
, fetchpatch
, python3Packages
, glibcLocales
, coreutils
, git
, python3
}:

python3Packages.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.9.14";

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner  = "xonsh";
    repo   = "xonsh";
    rev    = version;
    sha256 = "03g8ilg4dxin3v3rzccdxx9zf8rvyqpxakn1dlpqbgsnwdwa19p4";
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
  '';

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    HOME=$TMPDIR pytest -k 'not test_repath_backslash and not test_os and not test_man_completion and not test_builtins and not test_main and not test_ptk_highlight and not test_pyghooks'
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
