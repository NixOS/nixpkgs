{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "otpauth";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dim13";
    repo = "otpauth";
    rev = "v${version}";
    sha256 = "sha256-1+A1oXY5sKMr9dVa/4vB+ZkfZSDdhag5y5LfM7OJmKo=";
  };

  vendorHash = "sha256-ZRCwZGlWzlWh+E3KUH83639Tfck7bwE36wXVnG7EQIE=";

  meta = with lib; {
    description = "Google Authenticator migration decoder";
    mainProgram = "otpauth";
    homepage = "https://github.com/dim13/otpauth";
    license = licenses.isc;
    maintainers = with maintainers; [ ereslibre ];
  };
}
