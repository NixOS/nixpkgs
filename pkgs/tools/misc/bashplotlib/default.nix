{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "bashplotlib";
  version = "2017-10-11";

  src = fetchFromGitHub {
    owner = "glamp";
    repo = "bashplotlib";
    rev = "fdc52be2c1fed13753692eced328143ab1db6f3d";
    sha256 = "1ycql6j65zywyav2n3c0x1i5cm9w6glzqc3v0cgdvv1bdg4wi0gf";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/glamp/bashplotlib;
    description = "Plotting in the terminal";
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.mit;
  };
}
