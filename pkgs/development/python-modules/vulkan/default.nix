{
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  inflection,
  jinja2,
  lib,
  pysdl2,
  setuptools,
  vulkan-loader,
  wheel,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "vulkan";
  version = "1.3.275.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "realitix";
    repo = "vulkan";
    tag = version;
    hash = "sha256-b1jHNKdHF7pIC6H4O2yxy36Ppb60J0uN2P0WaCw51Gc=";
  };

  postPatch = ''
    substituteInPlace vulkan/_vulkan.py \
      --replace-fail 'lib = ffi.dlopen(name)' 'lib = ffi.dlopen("${vulkan-loader}/lib/" + name)'
  '';

  buildInputs = [
    vulkan-loader
  ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    inflection
    jinja2
    pysdl2
    xmltodict
    cffi
  ];

  pythonImportsCheck = [
    "vulkan"
  ];

  meta = {
    description = "Ultimate Python binding for Vulkan API";
    homepage = "https://github.com/realitix/vulkan";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      grimmauld
      getchoo
    ];
  };
}
