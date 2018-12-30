{ stdenv, fetchFromGitHub, python3Packages, glibcLocales, coreutils, git }:

python3Packages.buildPythonApplication rec {
  pname = "xonsh";
  version = "0.8.3";

  # fetch from github because the pypi package ships incomplete tests
  src = fetchFromGitHub {
    owner  = "scopatz";
    repo   = "xonsh";
    rev    = "refs/tags/${version}";
    sha256 = "1qnghqswvqlwv9121r4maibmn2dvqmbr3fhsnngsj3q7plfp7yb2";
  };

  LC_ALL = "en_US.UTF-8";
  postPatch = ''
    sed -ie "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie 's|/usr/bin/env|${coreutils}/bin/env|' scripts/xon.sh

    patchShebangs .
  '';

  checkPhase = ''
    HOME=$TMPDIR \
      pytest \
        -k 'not test_man_completion and not test_indir and not test_xonsh_party and not test_foreign_bash_data and not test_script and not test_single_command_no_windows and not test_redirect_out_to_file and not test_sourcefile and not test_printname and not test_printfile'
  '';

  checkInputs = [ python3Packages.pytest glibcLocales git ];

  propagatedBuildInputs = with python3Packages; [ ply prompt_toolkit pygments ];

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
