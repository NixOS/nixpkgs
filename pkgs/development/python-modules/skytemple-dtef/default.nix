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
  version = "1.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    hash = "sha256-QL+nLmjz0wCED2RjidIDK0tB6mAPnoaSJWpyLFu0pP4=";
  };

  propagatedBuildInputs = [
    pillow
    skytemple-files
  ];

  checkInputs = [
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
