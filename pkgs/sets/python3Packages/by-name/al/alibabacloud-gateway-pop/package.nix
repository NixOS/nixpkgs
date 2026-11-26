{
  lib,
  alibabacloud-tea-openapi,
  buildPythonPackage,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-gateway-pop";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_gateway_pop";
    inherit (finalAttrs) version;
    hash = "sha256-SYdX+Psa/GqpYKlBz8NikkOA17wCGxi2BCfX5VXFXr0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-tea-openapi
    darabonba-core
  ];

  pythonImportsCheck = [ "alibabacloud_gateway_pop" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Gateway POP SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-gateway-pop/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
