{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "wasabi";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xxjc9bvvcaz1qq1jyhcxyl2v39jz8d8dz4zhpfbc7dz53kq6b7r";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest wasabi/tests
  '';

  meta = with stdenv.lib; {
    description = "A lightweight console printing and formatting toolkit";
    homepage = https://github.com/ines/wasabi;
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
    };
}
