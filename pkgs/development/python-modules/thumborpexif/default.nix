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
    sha256 = "96dcc03ea6066d9546baf54f6841f4048b0b24a291eed65d098b3348c8872d99";
  };

  meta = with stdenv.lib; {
    description = "Module to parse and edit the EXIF data tags in a JPEG image";
    homepage = http://www.benno.id.au/code/pexif/;
    license = licenses.mit;
  };

}
