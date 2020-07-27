{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i012bf3d30kq13zjr45fxvn7a99jdjw4ica9kzaiw96hh1myi5k";
  };

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A library for deferring decorator actions";
    homepage = https://pylonsproject.org/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
