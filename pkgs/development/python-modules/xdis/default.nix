{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "5.0.10";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "sha256-/3qyMgliua7W4Va1HdRbHyiR/eBQzHK+GrZVAMvMhLA=";
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
