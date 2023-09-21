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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "sibson";
    repo = "vncdotool";
    rev = "v${version}";
    sha256 = "0h3ccr8zi7xpgn6hz43x1045x5l4bhha7py8x00g8bv6gaqlbwxn";
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
