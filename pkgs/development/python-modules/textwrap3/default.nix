{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textwrap3";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-UAju69sjb2MD3NaPGLhW01X2GXUR2VK6dLx15A4MNBQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Textwrap from Python 3.6 backport plus a few tweaks";
    homepage = "https://github.com/jonathaneunice/textwrap3";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
