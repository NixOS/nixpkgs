{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346";
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
