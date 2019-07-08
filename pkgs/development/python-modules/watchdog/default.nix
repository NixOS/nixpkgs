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
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "965f658d0732de3188211932aeb0bb457587f04f63ab4c1e33eab878e9de961d";
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
