{ lib, buildPythonPackage, fetchFromGitHub
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "1h4j8hincf49zyd0rvn4bh0ypj8836y8vz3d496ycb9gjzkr6044";
  };

  patches = [
    ./python375.patch # Add Python 3.7.5 as a 3.7 release. Fixed upstream in version 4.1.1
    ./python2717.patch # Add Python 2.7.17 as a 2.7 release. Fixed upstream in version 4.1.3
  ];

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six click ];

  checkPhase = ''
    make check
  '';

  meta = with lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = https://github.com/rocky/python-xdis/;
    license = licenses.gpl2;
  };

}
