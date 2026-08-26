{
  lib,
  async-timeout,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  intelhex,
  pyserial,
  pytest-asyncio,
  pytestCheckHook,
  smp,
}:

buildPythonPackage rec {
  pname = "smpclient";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intercreate";
    repo = "smpclient";
    tag = version;
    hash = "sha256-5o2z+cyOVpTNpOdc9GfFNmqcOhbGgbFM0qGng44E1xE=";
  };

  env.HATCH_BUILD_HOOK_VCS_VERSION = version;
  __darwinAllowLocalNetworking = true;

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    async-timeout
    intelhex
    smp
  ];

  optional-dependencies = {
    serial = [ pyserial ];
    ble = [ bleak ];
    udp = [ ];
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  pythonImportsCheck = [ "smpclient" ];

  meta = {
    description = "Simple Management Protocol (SMP) Client for remotely managing MCU firmware";
    homepage = "https://github.com/intercreate/smpclient";
    changelog = "https://github.com/intercreate/smpclient/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
  };
}
