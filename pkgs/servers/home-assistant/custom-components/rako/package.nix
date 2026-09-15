{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  python-rako-2025,
  nix-update-script,
}:

buildHomeAssistantComponent rec {
  owner = "SimonLeigh";
  domain = "rako";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "SimonLeigh";
    repo = "hacs_rako";
    rev = "df4e9ba7d75ff877a5a555a0d9e5666b5741b918";
    hash = "sha256-8isOyJiUnd5RTA+s9P3bnQX9dzTTKYGH106Hi1Jgetg=";
  };

  dependencies = [ python-rako-2025 ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Home Assistant integration for Rako lighting systems";
    changelog = "https://github.com/SimonLeigh/hacs_rako/releases/tag/v${version}";
    homepage = "https://github.com/SimonLeigh/hacs_rako";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}
