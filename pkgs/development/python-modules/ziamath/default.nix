{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, ziafont
, pytestCheckHook
, nbval
, latex2mathml
}:

buildPythonPackage rec {
  pname = "ziamath";
  version = "0.9";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cdelker";
    repo = pname;
    rev = version;
    hash = "sha256-ISd+J7R8qZ0NXdlyHMj+torzr+541UAhNCSaUH8ytSQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ziafont
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nbval
    latex2mathml
  ];

  pytestFlagsArray = [ "--nbval-lax" ];

  # Prevent the test suite from attempting to download fonts
  postPatch = ''
    substituteInPlace test/styles.ipynb \
      --replace '"def testfont(exprs, fonturl):\n",' '"def testfont(exprs, fonturl):\n", "    return\n",' \
      --replace "mathfont='FiraMath-Regular.otf', " ""
  '';

  pythonImportsCheck = [ "ziamath" ];

  meta = with lib; {
    description = "Render MathML and LaTeX Math to SVG without Latex installation";
    homepage = "https://ziamath.readthedocs.io/en/latest/";
    changelog = "https://ziamath.readthedocs.io/en/latest/changes.html";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
