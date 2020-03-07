{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, progress
, pyserial
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "stm32loader";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0135qzxlrivvkq6wgkw7shfz94n755qs2c1754p1hc2jk0nqayrg";
  };

  propagatedBuildInputs = [ progress pyserial ];

  checkInputs = [ pytest ] ++ lib.optional isPy27 mock;

  checkPhase = ''
    pytest --strict tests/unit
  '';

  meta = with lib; {
    description = "Flash firmware to STM32 microcontrollers in Python";
    homepage = https://github.com/florisla/stm32loader;
    changelog = "https://github.com/florisla/stm32loader/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ emily ];
  };
}
