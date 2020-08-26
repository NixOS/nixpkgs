{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.4.4";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "bfcf9411ef4bf3db7579063e0546938b1edda3d69f4e1fb8756991f5951f85d4";
  };

  meta = with stdenv.lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = "https://github.com/jupyter/testpath";
  };

}
