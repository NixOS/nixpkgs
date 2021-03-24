{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "5.0.8";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "01g1bk7rscwmvr2i183z0y2bs1iw7bxk7c5rcf9gf25242nppv6a";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six click ];

  checkPhase = ''
    make check
  '';
  pythonImportsCheck = [ "xdis" ];

  meta = with lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = "https://github.com/rocky/python-xdis/";
    license = licenses.gpl2Plus;
  };
}
