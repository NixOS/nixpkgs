{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "xmind";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zhuifengshen";
    repo = pname;
    rev = "v${version}";
    sha256 = "xC1WpHz2eHb5+xShM/QUQAIYnJNyK1EKWbTXJKhDwbQ=";
  };

  # Projec thas no tests
  doCheck = false;

  pythonImportsCheck = [ "xmind" ];

  meta = with lib; {
    description = "Python module to create mindmaps";
    homepage = "https://github.com/zhuifengshen/xmind";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
