{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZSPv4meyIYqNJm6SvqnpOjTtRGvfkUOAxn3JHmK5UEQ=";
  };

  vendorSha256 = "sha256-8UcHRFt/O8RgZRxODIJZ16zvBi7FmadYdA/NUH9kfEo=";

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
