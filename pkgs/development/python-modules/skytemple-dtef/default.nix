{ lib, buildPythonPackage, fetchFromGitHub, skytemple-files }:

buildPythonPackage rec {
  pname = "skytemple-dtef";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "177ydif01fai6z5yhgpa27pzfgabblzhl8nsczczcmw74vxqwzyc";
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
