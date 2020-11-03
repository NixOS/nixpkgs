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
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4214e1379d128b0588021880ccaf40317ee156d4603ac388b9adcf29165e0c04";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ pkgs.darwin.apple_sdk.frameworks.CoreServices ];
  requiredPythonModules = [ argh pathtools pyyaml ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
