{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xmind";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhuifengshen";
    repo = "xmind";
    rev = "v${version}";
    sha256 = "xC1WpHz2eHb5+xShM/QUQAIYnJNyK1EKWbTXJKhDwbQ=";
  };

  build-system = [ setuptools ];

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [ "xmind" ];

  meta = {
    description = "Python module to create mindmaps";
    homepage = "https://github.com/zhuifengshen/xmind";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
