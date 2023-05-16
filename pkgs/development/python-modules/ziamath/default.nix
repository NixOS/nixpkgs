{ lib
, buildPythonPackage
, pythonOlder
<<<<<<< HEAD
, fetchFromGitHub
=======
, fetchFromBitbucket
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ziafont
, pytestCheckHook
, nbval
, latex2mathml
}:

buildPythonPackage rec {
  pname = "ziamath";
<<<<<<< HEAD
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-Bbwq4Ods3P/724KO94jSmMLD1ubfaMHP/gTlOL/2pnE=";
=======
  version = "0.7";

  disabled = pythonOlder "3.8";

  src = fetchFromBitbucket {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-JuuCDww0EZEHZLxB5oQrWEJpv0szjwe4iXCRGl7OYTA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    ziafont
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    latex2mathml
  ];

  pytestFlagsArray = [ "--nbval-lax" ];

<<<<<<< HEAD
  # Prevent the test suite from attempting to download fonts
  postPatch = ''
    substituteInPlace test/styles.ipynb \
      --replace '"def testfont(exprs, fonturl):\n",' '"def testfont(exprs, fonturl):\n", "    return\n",' \
      --replace "mathfont='FiraMath-Regular.otf', " ""
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "ziamath" ];

  meta = with lib; {
    description = "Render MathML and LaTeX Math to SVG without Latex installation";
    homepage = "https://ziamath.readthedocs.io/en/latest/";
    changelog = "https://ziamath.readthedocs.io/en/latest/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
