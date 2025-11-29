{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  rakopy,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "princekama";
  domain = "rako";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "princekama";
    repo = "home-assistant-rako";
    rev = "v${version}";
    hash = "sha256-IwtYigUflnXgISrP/+F75Jy7G2WrgIxoyzqG4zoYP34=";
  };

  dependencies = [ rakopy ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Home Assistant integration for Rako Controls";
    changelog = "https://github.com/princekama/home-assistant-rako/releases/tag/v${version}";
    homepage = "https://github.com/princekama/home-assistant-rako";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}