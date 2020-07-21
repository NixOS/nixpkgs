{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "136c5qwmvpkdy4njpcwhppnhah7jjlhhjzzzk5lpk8i6f4fz2xg8";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest wasabi/tests
  '';

  meta = with stdenv.lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = "https://github.com/ines/wasabi";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
