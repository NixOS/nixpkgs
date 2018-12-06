{ stdenv
, buildPythonPackage
, fetchPypi
, python
, cffi
}:

buildPythonPackage rec {
  pname = "xattr";
  version = "0.7.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nbqfghgy26jyp5q7wl3rj78wr8s39m5042df2jlldg3fx6j0417";
  };

  propagatedBuildInputs = [ cffi ];

  # https://github.com/xattr/xattr/issues/43
  doCheck = false;

  postBuild = ''
    ${python.interpreter} -m compileall -f xattr
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/xattr/xattr;
    description = "Python wrapper for extended filesystem attributes";
    license = licenses.mit;
  };

}
