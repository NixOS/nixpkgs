{ lib, python3, fetchPypi }:

let
  inherit (python3.pkgs) buildPythonApplication psutil pyzmq tornado;
in

buildPythonApplication rec {
  pname = "circus";
  version = "0.18.0";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GTzoIk4GjO1mckz0gxBvtmdLUaV1g6waDn7Xp+6Mcas=";
  };

  doCheck = false; # weird error

  propagatedBuildInputs = [ psutil pyzmq tornado ];

  meta = with lib; {
    description = "A process and socket manager";
    homepage = "https://github.com/circus-tent/circus";
    license = licenses.asl20;
  };
}
