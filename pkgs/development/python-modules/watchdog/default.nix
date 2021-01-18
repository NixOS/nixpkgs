{ lib, stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, pkgs
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e38bffc89b15bafe2a131f0e1c74924cf07dcec020c2e0a26cccd208831fcd43";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ pkgs.darwin.apple_sdk.frameworks.CoreServices ];
  propagatedBuildInputs = [ argh pathtools pyyaml ];

  doCheck = false;

  meta = with lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
