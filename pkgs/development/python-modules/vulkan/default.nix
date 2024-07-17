{
  lib,
  buildPythonPackage,
  fetchPypi,
  vulkan-loader,
  pysdl2,
  jinja2,
  inflection,
  xmltodict,
  cffi,
}:

buildPythonPackage rec {
  pname = "vulkan";
  version = "1.3.275.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XPeWHLSk5g0GPrgVFHwiiSRFdbdaRRIInMboqVm5ltI=";
  };

  postPatch = ''
    substituteInPlace vulkan/_vulkan.py \
      --replace-fail 'lib = ffi.dlopen(name)' 'lib = ffi.dlopen("${vulkan-loader}/lib/" + name)'
  '';

  dependencies = [
    pysdl2
    jinja2
    inflection
    xmltodict
    cffi
  ];

  # Not needed as we already patched pysdl2 with our SDL path
  pythonRemoveDeps = [ "pysdl2-dll" ];

  pythonImportsCheck = [ "vulkan" ];

  meta = {
    description = "Ultimate Python binding for Vulkan API";
    homepage = "https://github.com/realitix/vulkan";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aleksana ];
  };
}
