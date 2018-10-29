{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "thumbor-pexif";
  version = "0.14";
  disabled = ! isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "715cd24760c7c28d6270c79c9e29b55b8d952a24e0e56833d827c2c62451bc3c";
  };

  meta = with stdenv.lib; {
    description = "Module to parse and edit the EXIF data tags in a JPEG image";
    homepage = http://www.benno.id.au/code/pexif/;
    license = licenses.mit;
  };

}
