{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "30.0.3";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-bTXxzGf7mXQ0VfAQhaKAOYtOVAEVC71R3eRJej0zfJs=";
  };

  vendorHash = "sha256-FyV3oaI4MKl0LKJf23XIeUmvFsa1DvQw2pq5Heza3Ws=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
