{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  matplotlib,
  pytest,
}:

buildPythonPackage {
  pname = "showit";
  version = "1.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "freeman-lab";
    repo = "showit";
    rev = "ef76425797c71fbe3795b4302c49ab5be6b0bacb"; # no tags in repo
    sha256 = "0xd8isrlwwxlgji90lly1sq4l2a37rqvhsmyhv7bd3aj1dyjmdr6";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "Simple and sensible display of images";
    homepage = "https://github.com/freeman-lab/showit";
    license = licenses.mit;
    maintainers = [ ];
  };
}
