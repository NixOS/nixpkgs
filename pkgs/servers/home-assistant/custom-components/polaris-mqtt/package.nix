{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "samoswall";
  domain = "polaris";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "samoswall";
    repo = "polaris-mqtt";
    tag = "v${version}";
    hash = "sha256-ei0O+PTi/nV8Jb3ul+52vsmQxC3irYu0YjBotqYoipc=";
  };

  meta = {
    description = "Polaris IQ Home devices integration to Home Assistant";
    homepage = "https://github.com/samoswall/polaris-mqtt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.k900 ];
  };
}
