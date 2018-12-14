{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "thumbor-pexif";
  version = "0.14.1";
  disabled = ! isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "169dhz44hcwb15fxdvlil8j0p2q4yi0nhkzmp939av86lqzc1p4n";
  };

  meta = with stdenv.lib; {
    description = "Module to parse and edit the EXIF data tags in a JPEG image";
    homepage = http://www.benno.id.au/code/pexif/;
    license = licenses.mit;
  };

}
