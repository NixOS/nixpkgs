{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
  numpy,
  # Test dependencies
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  aioresponses,
}:

buildHomeAssistantComponent rec {
  owner = "bramstroker";
  domain = "powercalc";
  version = "1.17.21";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-powercalc";
    tag = "v${version}";
    hash = "sha256-vXehSBH5weiWnv+6++mhPtRSM6vknshdm1hxp+hq0N4=";
  };

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
    aioresponses
  ];

  preCheck = ''
    patchShebangs --build tests/setup.sh
    tests/setup.sh

    # Mock filesystem operations to avoid permission errors.
    cat >> tests/conftest.py << 'EOF'
    @pytest.fixture(autouse=True)
    def mock_filesystem_operations():
        with patch("os.makedirs"), patch("subprocess.check_call"), patch("subprocess.call", return_value=0):
            yield
    EOF
  '';

  disabledTests = [
    "test_discovery"
    "test_include"
    "test_library"
    "test_lightify_plug"
    "test_lut"
    "test_network"
    "test_power"
    "test_remote"
    "test_sensor"
    "test_shelly_plug"
    "test_smart_switch"
    "test_virtual_power_library"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/bramstroker/homeassistant-powercalc/releases/tag/${src.tag}";
    description = "Custom Home Assistant component for virtual power sensors";
    homepage = "https://github.com/bramstroker/homeassistant-powercalc";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.mit;
  };
}
