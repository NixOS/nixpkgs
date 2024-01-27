{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, pytestCheckHook
, pythonOlder
, skytemple-files
}:

buildPythonPackage rec {
  pname = "skytemple-dtef";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-ngIjM8DW9HQJpa/U2f1sy+6CeWdccayp60vbJmos+A8=";
  };

  propagatedBuildInputs = [
    pillow
    skytemple-files
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "skytemple_dtef"
  ];

  meta = with lib; {
    description = "A format for standardized rule-based tilesets with 256 adjacency combinations";
    homepage = "https://github.com/SkyTemple/skytemple-dtef";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 xfix ];
  };
}
