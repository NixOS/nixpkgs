{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pillow,
  pytestCheckHook,
  skytemple-files,
}:

buildPythonPackage rec {
  pname = "skytemple-dtef";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-dtef";
    rev = version;
    hash = "sha256-IsAHXl9HfjWDXi/n6Alndi+GnAr7pmbjz6wrBECra0Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pillow
    skytemple-files
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "skytemple_dtef" ];

  meta = {
    description = "Format for standardized rule-based tilesets with 256 adjacency combinations";
    homepage = "https://github.com/SkyTemple/skytemple-dtef";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
