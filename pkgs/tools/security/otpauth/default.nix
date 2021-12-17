{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-LGDeNkCxVLDVpwi5VFFL0DFsf8CexI7Nc5l+l2ASHaw=";
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
