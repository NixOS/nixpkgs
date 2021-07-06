{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "skytemple-icons";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "036bxy0n3p0ivcdaymj11z0nw555xjxxj15ja0rpjsvq1mqamd80";
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
