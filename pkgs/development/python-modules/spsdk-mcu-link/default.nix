{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  hidapi,
  pyusb,

  # tests
  click,
  pytestCheckHook,
  spsdk,
  writableTmpDirAsHomeHook,

  # passthru
  spsdk-mcu-link,
}:

buildPythonPackage (finalAttrs: {
  pname = "spsdk-mcu-link";
  version = "0.6.18";
  pyproject = true;
  __structuredAttrs = true;

  # Latest tag missing on GitHub
  src = fetchPypi {
    pname = "spsdk_mcu_link";
    inherit (finalAttrs) version;
    hash = "sha256-YOJpnh525r08FDXUVNA/GYNLMjjqCs1E852A9lt/gHc=";
  };

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    # unpackaged
    "libusb_package"
    "wasmtime"

    # cyclic dependency
    "spsdk"
  ];

  pythonRelaxDeps = [
    "hidapi"
    "pyusb"
  ];

  dependencies = [
    hidapi
    pyusb
  ];

  nativeCheckInputs = [
    click
    pytestCheckHook
    spsdk
    writableTmpDirAsHomeHook
  ];

  # Cyclic dependency with spsdk
  doCheck = false;

  passthru.tests = {
    pytest = spsdk-mcu-link.overridePythonAttrs {
      pythonImportsCheck = [
        "spsdk_mcu_link"
      ];

      doCheck = true;
    };
  };

  meta = {
    description = "Debugger probe plugin for SPSDK supporting LPC-Link/MCU-Link from NXP";
    homepage = "https://pypi.org/project/spsdk-mcu-link";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
