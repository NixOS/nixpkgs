{
  buildHomeAssistantComponent,
  lib,
  fetchFromGitHub,
  simple-pid,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,
  syrupy,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "bvweerd";
  domain = "simple_pid_controller";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bvweerd";
    repo = "simple_pid_controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k/JT3sdGNYETWMat5hoiGv81N77Qz7Ks354vtk5PnvQ=";
  };

  dependencies = [ simple-pid ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-homeassistant-custom-component
    syrupy
  ];

  meta = {
    changelog = "https://github.com/bvweerd/simple_pid_controller/releases/tag/${finalAttrs.src.tag}";
    description = "PID Controller integration for Home Assistant";
    homepage = "https://github.com/bvweerd/simple_pid_controller";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
