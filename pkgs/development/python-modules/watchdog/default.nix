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
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ss58k33l5vah894lykid6ar6kw7z1f29cl4hzr5xvgs8fvfyq65";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ pkgs.darwin.apple_sdk.frameworks.CoreServices ];
  propagatedBuildInputs = [ argh pathtools pyyaml ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python API and shell utilities to monitor file system events";
    homepage = "https://github.com/gorakhargosh/watchdog";
    license = licenses.asl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
