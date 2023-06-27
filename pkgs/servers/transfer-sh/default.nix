{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "transfer-sh";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dutchcoders";
    repo = "transfer.sh";
    rev = "v${version}";
    hash = "sha256-87BqRJjjyXHejYbmJiG6nEPmThT1h1jW3XWq3FlzE5I=";
  };

  vendorHash = "sha256-CpEdWhvvQhvTWra7xQnXgJWKDnaod6NHkGiz4hoTy4g=";

  meta = with lib; {
    description = "Easy and fast file sharing and pastebin server with access from the command-line";
    homepage = "https://github.com/dutchcoders/transfer.sh";
    changelog = "https://github.com/dutchcoders/transfer.sh/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ pinpox ];
  };
}
