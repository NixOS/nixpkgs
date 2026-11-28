{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  hatchling,
  pytest-cov-stub,
  pytest-httpbin,
  pytestCheckHook,
  typing-extensions,
}:

let
  tlsClientLibrary = fetchurl {
    url = "https://github.com/bogdanfinn/tls-client/releases/download/v1.16.0/tls-client-linux-ubuntu-amd64-1.16.0.so";
    hash = "sha256-LshTSWY0VF56fqAocVdjlI1Vu92XrKfsqp/qjC67CN8=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "tls-client";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FlorianREGAZ";
    repo = "Python-Tls-Client";
    tag = finalAttrs.version;
    hash = "sha256-P146wQ43dXaVOLkD9hat14XS6u9FWllsyrOeyXknD98=";
  };

  postPatch = ''
    cp ${tlsClientLibrary} tls_client/dependencies/tls-client-linux-ubuntu-amd64.so
  '';

  build-system = [ hatchling ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-httpbin
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tls_client" ];

  meta = {
    description = "Advanced HTTP Library";
    homepage = "https://github.com/FlorianREGAZ/Python-Tls-Client";
    changelog = "https://github.com/FlorianREGAZ/Python-Tls-Client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
