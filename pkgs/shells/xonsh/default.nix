{ stdenv, fetchFromGitHub, python3Packages, glibcLocales, coreutils }:

python3Packages.buildPythonApplication rec {
  name = "xonsh-${version}";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "scopatz";
    repo = "xonsh";
    rev = version;
    sha256= "1lx95i468px908y18fa9fmfgmjsydhkpas89dxbwfnybqxxyd3ls";
  };

  ## The logo xonsh prints during build contains unicode characters, and this
  ## fails because locales have not been set up in the build environment.
  ## We can fix this on Linux by setting:
  ##    export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
  ## but this would not be a cross platform solution, so it's simpler to just
  ## patch the setup.py script to not print the logo during build.
  #prePatch = ''
  #  substituteInPlace setup.py --replace "print(logo)" ""
  #'';
  patchPhase = ''
    rm xonsh/winutils.py
    sed -i -e "s|/bin/ls|${coreutils}/bin/ls|" tests/test_execer.py
    sed -ie 's|test_win_ipconfig|_test_win_ipconfig|g' tests/test_execer.py
    sed -ie 's|test_ipconfig|_test_ipconfig|g' tests/test_execer.py
    rm tests/test_main.py
    rm tests/test_man.py
    rm tests/test_replay.py
  '';

  checkPhase = ''
    HOME=$TMPDIR XONSH_INTERACTIVE=0 nosetests -x
  '';

  buildInputs = with python3Packages; [ glibcLocales nose pytest ];
  propagatedBuildInputs = with python3Packages; [ ply prompt_toolkit ];

  meta = with stdenv.lib; {
    description = "A Python-ish, BASHwards-compatible shell";
    homepage = "http://xonsh.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ spwhitt garbas vrthra ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/xonsh";
  };
}
