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
    rev = "refs/tags/v${version}";
    hash = "sha256-ZSPv4meyIYqNJm6SvqnpOjTtRGvfkUOAxn3JHmK5UEQ=";
  };

  vendorHash = "sha256-8UcHRFt/O8RgZRxODIJZ16zvBi7FmadYdA/NUH9kfEo=";

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    changelog = "https://github.com/nats-io/nats-top/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
