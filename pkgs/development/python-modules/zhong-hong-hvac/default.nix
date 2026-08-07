{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "zhong-hong-hvac";
  version = "1.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crhan";
    repo = "ZhongHongHVAC";
    tag = "v${version}";
    hash = "sha256-ZCbo7U6bevnzybVVplSgdFLiuz9+HXiE0r/8sYJ+euQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ attrs ];

  # Tests require network hardware connection
  doCheck = false;

  pythonImportsCheck = [ "zhong_hong_hvac" ];

  meta = {
    description = "Python library for interfacing with ZhongHong HVAC controller";
    homepage = "https://github.com/crhan/ZhongHongHVAC";
    changelog = "https://github.com/crhan/ZhongHongHVAC/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
