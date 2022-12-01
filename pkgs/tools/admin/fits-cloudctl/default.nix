{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-y3sgk3BDyfByWKIY4wG/Od4Q3OhmDuFhkKlTQHa3TdE=";
  };

  vendorSha256 = "sha256-xTO7mxui9ydwjF3hudX2i8dP2xpsGM2X0cqq0oaK0HE=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
