{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "skytemple-icons";
  version = "1.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-icons";
    rev = version;
    sha256 = "0wagdvzks9irdl5lj8sfqkkvfwwmdpvjyzx6424shvpp5mk28dcv";
  };

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_icons" ];

  meta = {
    homepage = "https://github.com/SkyTemple/skytemple-icons";
    description = "Icons for SkyTemple";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
