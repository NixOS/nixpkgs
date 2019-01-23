{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "sslib";
  version = "0.2.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b5zrjkvx4klmv57pzhcmvbkdlyn745mn02k7hp811hvjrhbz417";
  };

  # No tests available
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jqueiroz/python-sslib;
    description = "A Python3 library for sharing secrets";
    license = licenses.mit;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
