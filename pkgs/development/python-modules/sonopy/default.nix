{ lib
, fetchPypi
, buildPythonPackage
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "sonopy";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i8chwx26b84i4p8xpqvixfalm4532hz72njnhxiiwgmbc2jrkfp";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  meta = with lib; {
    description = "A simple audio feature extraction library";
    homepage = "https://github.com/MycroftAI/sonopy";
    maintainers = with maintainers; [ timokau ];
    license = licenses.asl20;
  };
}
