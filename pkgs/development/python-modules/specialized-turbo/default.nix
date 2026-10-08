{
  lib,
  bleak,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "specialized-turbo";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JamieMagee";
    repo = "specialized-turbo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ey9XQocBDJDNenCnJ2iz4jcJ5cB+BiTt0ngvOX6PKik=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bleak
    cryptography
  ];

  optional-dependencies = {
    cloud = [ httpx ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.cloud;

  pythonImportsCheck = [ "specialized_turbo" ];

  meta = {
    description = "Python library for communicating with Specialized Turbo e-bikes over Bluetooth Low Energy";
    homepage = "https://github.com/JamieMagee/specialized-turbo";
    changelog = "https://github.com/JamieMagee/specialized-turbo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
