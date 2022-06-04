{ lib, buildPythonPackage, fetchFromGitHub, skytemple-files }:

buildPythonPackage rec {
  pname = "skytemple-dtef";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "QL+nLmjz0wCED2RjidIDK0tB6mAPnoaSJWpyLFu0pP4=";
  };

  propagatedBuildInputs = [ skytemple-files ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_dtef" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-dtef";
    description = "A format for standardized rule-based tilesets with 256 adjacency combinations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}
