{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "samoswall";
  domain = "polaris";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "samoswall";
    repo = "polaris-mqtt";
    tag = "v${version}";
    hash = "sha256-/HMR+BZuwAoqFfELkjhT3k5NKMc2ahE/I3DTR1lQ5L0=";
  };

  meta = {
    description = "Polaris IQ Home devices integration to Home Assistant";
    homepage = "https://github.com/samoswall/polaris-mqtt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.k900 ];
  };
}
