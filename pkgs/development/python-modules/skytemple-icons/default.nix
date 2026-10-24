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
    hash = "sha256-mzUkZi33bqiJIKZ/L/dtlXO358ROI0kLbTkmPf9uT3E=";
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
