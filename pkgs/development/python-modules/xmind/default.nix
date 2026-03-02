{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "xmind";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zhuifengshen";
    repo = "xmind";
    rev = "v${version}";
    sha256 = "xC1WpHz2eHb5+xShM/QUQAIYnJNyK1EKWbTXJKhDwbQ=";
  };

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
