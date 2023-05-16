{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, matplotlib
, pytest
}:

buildPythonPackage rec {
  pname = "showit";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "freeman-lab";
    repo = pname;
    rev = "ef76425797c71fbe3795b4302c49ab5be6b0bacb"; # no tags in repo
    sha256 = "0xd8isrlwwxlgji90lly1sq4l2a37rqvhsmyhv7bd3aj1dyjmdr6";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "simple and sensible display of images";
    homepage = "https://github.com/freeman-lab/showit";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
