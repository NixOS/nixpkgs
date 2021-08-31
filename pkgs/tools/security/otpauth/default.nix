{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-Jr1cZbXKZa6M7tIex67SjDPkWSYHWSZ7vRYd8us7Oek=";
  };

  runVend = true;
  vendorSha256 = "sha256-s0pcm3fO50cuMEJ6Pp7qay6BGGa+FCiBegUbQlB0OnY=";
  doCheck = true;

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
