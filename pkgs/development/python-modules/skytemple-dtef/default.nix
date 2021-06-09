{ lib, buildPythonPackage, fetchFromGitHub, skytemple-files }:

buildPythonPackage rec {
  pname = "skytemple-dtef";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0hisg7gq6ph0as9vvx2p1h104bn6x2kx8y477p9zcqc71f3yrx82";
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
