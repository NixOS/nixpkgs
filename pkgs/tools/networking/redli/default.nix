{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "redli";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "IBM-Cloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uXTzDRluBP9pm0SM8sIiGIvvbwATO60JQfQpXWGl5EA=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Humane alternative to the Redis-cli and TLS";
    homepage = "https://github.com/IBM-Cloud/redli";
    license = licenses.asl20;
    maintainers = with maintainers; [ tchekda ];
    mainProgram = "redli";
  };
}
