{ python3Packages, fetchFromGitHub , tarsnap }:

python3Packages.buildPythonApplication rec {
  name = "tarsnapper-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "miracle2k";
    repo = "tarsnapper";
    rev = version;
    sha256 = "03db49188f4v1946c8mqqj30ah10x68hbg3a58js0syai32v12pm";
  };

  buildInputs = with python3Packages; [ nose pytest ];

  checkPhase = ''
    py.test .
  '';

  propagatedBuildInputs = with python3Packages; [ pyyaml dateutil pexpect ];

  patches = [ ./remove-argparse.patch ];

  makeWrapperArgs = ["--prefix PATH : ${tarsnap}/bin"];
}
