{ lib, fetchFromGitHub, mupen64plus, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "m64py";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mupen64plus";
    repo = "mupen64plus-ui-python";
    # As of 2020-01-01, the latest release of m64py is 0.2.4.  However,
    # this was released in 2017, and there hasn't been a new release since
    # then.  There have been a few commits to the repo since 0.2.4
    # improving things, so we use the latest commit from the repo as of
    # 2020-01-01.
    rev = "30e05dd9a357bf6e56fc2b23cf64f5d0ada03192";
    sha256 = "1x5shgg4jrafyb0axk39m3n6p28n0ylniv5hchrh9qbqq6zb1v5r";
  };

  propagatedBuildInputs =
    (with python3Packages; [
      pyqt5
      pysdl2
    ]) ++
    [ mupen64plus
    ];

  nativeBuildInputs =
    (with python3Packages; [
      pyqt5
    ]) ++
    [ wrapQtAppsHook
    ];

  dontWrapQtApps = true;

  postFixup = ''
    wrapPythonPrograms

    wrapQtApp "$out/bin/m64py" \
      --prefix PATH : "${mupen64plus}/bin" \
      --prefix LD_LIBRARY_PATH : "${mupen64plus}/lib" \
      --run 'cd "${mupen64plus}/lib"'
  '';

  meta = with lib; {
    description = "A Qt5 front-end (GUI) for Mupen64Plus";
    maintainers = with maintainers; [ cdepillabout ];
    license = licenses.gpl3;
    homepage = "https://github.com/mupen64plus/mupen64plus-ui-python";
  };
}
