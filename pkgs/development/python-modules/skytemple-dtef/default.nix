{ lib, buildPythonPackage, fetchFromGitHub, skytemple-files }:

buildPythonPackage rec {
  pname = "skytemple-dtef";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0l2b66z5ngyas3ijbzwz2wizw46kz47f8jr729pzbg4wbqbqjihr";
  };

  propagatedBuildInputs = [ skytemple-files ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_dtef" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-dtef";
    description = "A format for standardized rule-based tilesets with 256 adjacency combinations";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
