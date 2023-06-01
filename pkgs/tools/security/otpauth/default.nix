{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-jeKxCuE3cA/oTEKwdrCGPchsrtaMyirTzv8oLl9gxtA=";
  };

  vendorHash = "sha256-jnIq7Zc2MauJReJ9a8TeqXXsvHixsBB+znmXAxcpqUQ=";
  doCheck = true;

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
