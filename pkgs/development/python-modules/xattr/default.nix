{ stdenv
, buildPythonPackage
, fetchPypi
, python
, cffi
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cb1b28eeab4fe99cc4350e831434142fce658f7d03f173ff7722144e6a47458";
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
