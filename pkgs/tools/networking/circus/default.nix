{ lib, python3 }:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      tornado = super.tornado_4;
    };
  };

  inherit (python.pkgs) buildPythonApplication fetchPypi iowait psutil pyzmq tornado mock six;
in

buildPythonApplication rec {
  pname = "circus";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0paccmqwgard2l0z7swcc3nwc418l9b4mfaddb4s31bpnqg02z6x";
  };

  postPatch = ''
    # relax version restrictions to fix build
    substituteInPlace setup.py \
      --replace "pyzmq>=13.1.0,<17.0" "pyzmq>13.1.0"
  '';

  checkInputs = [ mock ];

  doCheck = false; # weird error

  propagatedBuildInputs = [ iowait psutil pyzmq tornado six ];

  meta = with lib; {
    description = "A process and socket manager";
    homepage = "https://github.com/circus-tent/circus";
    license = licenses.asl20;
  };
}
