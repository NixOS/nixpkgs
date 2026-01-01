{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  msmart-ng,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "mill1000";
  domain = "midea_ac";
<<<<<<< HEAD
  version = "2015.12.0";
=======
  version = "2025.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-PXCL3vaCdIOHuv2eUSLxVwVBZNzfynzcKRfQqm1PGvw=";
=======
    hash = "sha256-fmVX+b7x4+172+mcJ8+LFhljQEQrhLFXwXn6eI1f36Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [ msmart-ng ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/mill1000/midea-ac-py/releases/tag/${src.tag}";
    description = "Home Assistant custom integration to control Midea (and associated brands) air conditioners via LAN";
    homepage = "https://github.com/mill1000/midea-ac-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    changelog = "https://github.com/mill1000/midea-ac-py/releases/tag/${src.tag}";
    description = "Home Assistant custom integration to control Midea (and associated brands) air conditioners via LAN";
    homepage = "https://github.com/mill1000/midea-ac-py";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      hexa
      emilylange
    ];
  };
}
