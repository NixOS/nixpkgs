{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiofiles,
  click,
  pytest-mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "w1thermsensor";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n7wK4N1mzZtUxtYu17qyuI4UjJh/59UGD0dvkOgcInA=";
  };

  postPatch = ''
    sed -i 's/3\.5\.\*/3.5/' setup.py
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ click ];

  optional-dependencies = {
    async = [ aiofiles ];
  };

  # Don't try to load the kernel module in tests.
  env.W1THERMSENSOR_NO_KERNEL_MODULE = 1;

  nativeCheckInputs = [
    pytest-mock
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "w1thermsensor" ];

  meta = {
    description = "Python interface to 1-Wire temperature sensors";
    mainProgram = "w1thermsensor";
    longDescription = ''
      A Python package and CLI tool to work with w1 temperature sensors like
      DS1822, DS18S20 & DS18B20 on the Raspberry Pi, Beagle Bone and other
      devices.
    '';
    homepage = "https://github.com/timofurrer/w1thermsensor";
    changelog = "https://github.com/timofurrer/w1thermsensor/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quentin ];
    platforms = lib.platforms.all;
  };
}
