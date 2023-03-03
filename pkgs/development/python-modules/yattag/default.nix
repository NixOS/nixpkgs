{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ap/z/TMKYCh4BOpzcKhBZrYk6/S3rZ7XiLfFd3m2UmM=";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = "https://www.yattag.org/";
  };
}
