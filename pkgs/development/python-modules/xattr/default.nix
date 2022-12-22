{ lib
, buildPythonPackage
, fetchPypi
, python
, cffi
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wS59gf+qBgWzrIwiwplKjhipzxxZKHobdyKiKJyVLsU=";
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
