{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  plugp100,
}:
buildHomeAssistantComponent rec {
  pname = "tapo";
  version = "2.11.0";
  src = fetchFromGitHub {
    owner = "petretiandrea";
    repo = "home-assistant-tapo-p100";
    rev = "v${version}";
    hash = "sha256-44tg0A8nDE2m0EflDnXobzN2CJXNKGoe+aTnbqFxD0s=";
  };

  propagatedBuildInputs = [
    plugp100
  ];

  meta = with lib; {
    changelog = "https://github.com/petretiandrea/home-assistant-tapo-p100/blob/v${version}/CHANGELOG.md";
    description = "A custom integration to control Tapo devices";
    homepage = "https://github.com/petretiandrea/home-assistant-tapo-p100";
    maintainers = with maintainers; [nyawox];
    license = licenses.mit;
  };
}
