{ stdenv
, buildPythonPackage
, fetchPypi
, argh
, pathtools
, pyyaml
, pkgs
}:

buildPythonPackage rec {
  pname = "watchdog";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qj1vqszxwfx6d1s66s96jmfmy2j94bywxiqdydh6ikpvcm8hrby";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ pkgs.darwin.apple_sdk.frameworks.CoreServices pkgs.darwin.cf-private ];
  propagatedBuildInputs = [ argh pathtools pyyaml ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = https://github.com/gorakhargosh/watchdog;
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
