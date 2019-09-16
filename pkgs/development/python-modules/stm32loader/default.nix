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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w6jg4dcyz6si6dcyx727sxi75wnl0j89xkiwqmsw286s1y8ijjw";
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
