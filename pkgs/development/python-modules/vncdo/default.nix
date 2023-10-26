{ lib, fetchFromGitHub
, buildPythonPackage, isPy27
, pillow
, twisted
, pexpect
, nose
, ptyprocess
}:

buildPythonPackage rec {
  pname = "vncdo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-m8msWa8uUuDEjEUlXHCgYi0HFPKXLVXpXLyuQ3quNbA=";
  };

  propagatedBuildInputs = [
    pillow
    twisted
    pexpect
    nose
    ptyprocess
  ];

  doCheck = !isPy27;

  meta = with lib; {
    homepage = "https://github.com/sibson/vncdotool";
    description = "A command line VNC client and python library";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
    mainProgram = pname;
    platforms = with platforms; linux ++ darwin;
  };
}
