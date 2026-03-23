{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vnoise";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plottertools";
    repo = "vnoise";
    rev = version;
    hash = "sha256-nflAh3vj48wneM0wy/+M+XD6GC63KZEIFb1x4SS46YI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vnoise" ];

  meta = {
    description = "Vectorized, pure-Python Perlin noise library";
    homepage = "https://github.com/plottertools/vnoise";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
