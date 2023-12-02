{ lib
, buildPythonPackage
, fetchPypi

# build-system
, flit-core

# dependenices
, progress
, pyserial

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "stm32loader";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QTLSEjdJtDH4GCamnKHN5pEjW41rRtAMXxyZZMM5K3w=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    progress
    pyserial
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  meta = with lib; {
    description = "Flash firmware to STM32 microcontrollers in Python";
    homepage = "https://github.com/florisla/stm32loader";
    changelog = "https://github.com/florisla/stm32loader/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ emily ];
  };
}
