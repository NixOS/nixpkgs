{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "3.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g2lh70837vigcbc1i58349wp2xzrhlsg2ahc92sn8d3jwxja4dk";
  };

  propagatedBuildInputs = [ nose six ];

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = https://github.com/rocky/python-xdis/;
    license = licenses.mit;
  };

}
