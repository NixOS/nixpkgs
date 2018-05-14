{ stdenv, fetchFromGitHub, python3Packages, glibcLocales, coreutils }:

python3Packages.buildPythonApplication rec {
  name = "xonsh-${version}";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "scopatz";
    repo = "xonsh";
    rev = version;
    sha256= "1893kkxvalx8ycjl27gixkh979kkp4ra00zb7m6a8cdllx6yhsgi";
  };

  LC_ALL = "en_US.UTF-8";
  postPatch = ''
    rm xonsh/winutils.py

    sed -ie "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' scripts/xon.sh

    patchShebangs .
  '';

  checkPhase = ''
    HOME=$TMPDIR XONSH_INTERACTIVE=0 \
      pytest \
        -k 'not test_man_completion and not test_printfile and not test_sourcefile and not test_printname ' \
        tests
  '';

  checkInputs = with python3Packages; [ pytest glibcLocales ];

  propagatedBuildInputs = with python3Packages; [ ply prompt_toolkit ];

  meta = with stdenv.lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = http://xon.sh/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ spwhitt garbas vrthra ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/xonsh";
  };
}
