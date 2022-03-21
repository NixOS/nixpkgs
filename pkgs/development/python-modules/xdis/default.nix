{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "6.0.3";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "1qvg3bwqzqxlzlixz2di3si7siy0ismq93wd57r8cqmxl54gva6h";
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
