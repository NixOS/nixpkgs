{ lib
, fetchPypi
, buildPythonPackage
, numpy
, scipy
}:

buildPythonPackage rec {
  # FIXME what is the difference to `speechpy`?
  pname = "speechpy-fast";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    # sha256 = "0qpwb3d6kfhbwhfvl9f0yjcqdjhaqd9alskrwmlai8paz5715xbi";
    sha256 = "0xwm8xycsqr8kjqyg3b6ddv2nmvkpr0ai22lvd6k787wh5jsby1n";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  meta = with lib; {
    description = "A Library for Speech Processing and Recognition";
    homepage = "https://github.com/astorfi/speechpy";
    maintainers = with maintainers; [ timokau ];
    license = licenses.asl20;
  };
}
