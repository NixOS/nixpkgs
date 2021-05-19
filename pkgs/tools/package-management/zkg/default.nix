{ lib, python3Packages, btest }:

with python3Packages;
buildPythonApplication rec {
  pname = "zkg";
  version = "2.0.7";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1z4xf650nsd74xs8yddqpj60wp92b2yyw9sp3qy07as98ppzgr2w";
  };

  propagatedBuildInputs = [ GitPython semantic-version configparser btest ];

  doCheck = false;

  meta = with lib; {
    description = "The Zeek package manager";
    homepage = "https://docs.zeek.org/projects/package-manager/";
    license = "University of Illinois/NCSA Open Source License";
    maintainers = [ maintainers.tobim ];
    platforms = platforms.all;
  };
}
