{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "hiraeth";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lukaswrz";
    repo = "hiraeth";
    rev = "v${version}";
    hash = "sha256-IjHQAJH6Kv65iDkVtJaVeAiMXCEyTTpUTTbW7I2Gxrc=";
  };

  vendorHash = "sha256-tyFAd5S1RUn1AA5DbUGsAuvwtLgOgTE6LUzW3clQE9I=";

  meta = {
    description = "Share files with an expiration date";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.lukaswrz ];
  };
}
