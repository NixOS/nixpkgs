{ stdenv
, buildPythonPackage
, fetchPypi
, python
, cffi
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0bbca828e04ef2d484a6522ae7b3a7ccad5e43fa1c6f54d78e24bb870f49d44";
  };

  propagatedBuildInputs = [ cffi ];

  # https://github.com/xattr/xattr/issues/43
  doCheck = false;

  postBuild = ''
    ${python.interpreter} -m compileall -f xattr
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/xattr/xattr;
    description = "Python wrapper for extended filesystem attributes";
    license = licenses.mit;
  };

}
