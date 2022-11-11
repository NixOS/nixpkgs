{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-toFBkUssU10ejoZzWnrm5o2P0p5Oq8kKP4vb2ASDC0s=";
  };

  vendorSha256 = "sha256-jnIq7Zc2MauJReJ9a8TeqXXsvHixsBB+znmXAxcpqUQ=";
  doCheck = true;

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
