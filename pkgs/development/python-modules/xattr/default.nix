{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf11c8c857215e3ef60b031e7807264f30af4348d7565a7e9b8dca70593753c7";
  };

  propagatedBuildInputs = [ cffi ];

  # https://github.com/xattr/xattr/issues/43
  doCheck = false;

  postBuild = ''
    ${python.interpreter} -m compileall -f xattr
  '';

  meta = with lib; {
    homepage = "https://github.com/xattr/xattr";
    description = "Python wrapper for extended filesystem attributes";
    license = licenses.mit;
  };

}
