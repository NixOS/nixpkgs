{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "skytemple-icons";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "0wagdvzks9irdl5lj8sfqkkvfwwmdpvjyzx6424shvpp5mk28dcv";
  };

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_icons" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-icons";
    description = "Icons for SkyTemple";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
