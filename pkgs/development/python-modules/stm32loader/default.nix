{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,

  # build-system
  flit-core,

  # dependenices
  progress,
  pyserial,

  # optional-dependencies
  intelhex,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "stm32loader";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QTLSEjdJtDH4GCamnKHN5pEjW41rRtAMXxyZZMM5K3w=";
  };

  patches = [
    # fix build with python 3.12
    # https://github.com/florisla/stm32loader/pull/79
    (fetchpatch2 {
      url = "https://github.com/florisla/stm32loader/commit/96f59b2984b0d0371b2da0360d6e8d94d0b39a68.patch?full_index=1";
      hash = "sha256-JUEjQWOnzeMA1OELS214OR7+MYUkCKN5lxwsmRoFbfo=";
    })
  ];

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    progress
    pyserial
  ];

  passthru.optional-dependencies = {
    hex = [ intelhex ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [ "tests/unit" ];

  meta = with lib; {
    description = "Flash firmware to STM32 microcontrollers in Python";
    mainProgram = "stm32loader";
    homepage = "https://github.com/florisla/stm32loader";
    changelog = "https://github.com/florisla/stm32loader/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
