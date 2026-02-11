{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "samoswall";
  domain = "polaris";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "samoswall";
    repo = "polaris-mqtt";
    tag = "v${version}";
    hash = "sha256-nT7sLN61XOakYL2kZXQc6qrEAIaf0jEfm4wxZ0viK8c=";
  };

  meta = {
    description = "Polaris IQ Home devices integration to Home Assistant";
    homepage = "https://github.com/samoswall/polaris-mqtt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.k900 ];
  };
}
