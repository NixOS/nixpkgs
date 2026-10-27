{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "zhong-hong-hvac";
  version = "1.0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crhan";
    repo = "ZhongHongHVAC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-epU8ll8CCgc6ICxKr0duebX8wrtnXOPvADftk8EJsdw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ attrs ];

  # Tests require network hardware connection
  doCheck = false;

  pythonImportsCheck = [ "zhong_hong_hvac" ];

  meta = {
    description = "Python library for interfacing with ZhongHong HVAC controller";
    homepage = "https://github.com/crhan/ZhongHongHVAC";
    changelog = "https://github.com/crhan/ZhongHongHVAC/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
