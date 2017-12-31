{ stdenv, buildPythonPackage, fetchPypi
}:
buildPythonPackage rec {
  version = "0.9.0";
  pname = "texttable";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08353848k7j5rsa6wq4casg7243db76lvval134q2f8w0wvw4wza";
  };

  meta = with stdenv.lib; {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = licenses.lgpl2;
  };
}
