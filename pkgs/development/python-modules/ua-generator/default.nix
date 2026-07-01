{
  lib,
  buildPythonPackage,
  certifi,
  charset-normalizer,
  fetchFromGitHub,
  idna,
  nix-update-script,
  pytestCheckHook,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "ua-generator";
  version = "2.1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "iamdual";
    repo = "ua-generator";
    tag = finalAttrs.version;
    hash = "sha256-mpwyhR50a0F8J9VUyOoYNF20IbOKaDl+JpQ1qkLIt6s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    charset-normalizer
    idna
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ua_generator" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Random user-agent generator";
    homepage = "https://github.com/iamdual/ua-generator";
    changelog = "https://github.com/iamdual/ua-generator/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
