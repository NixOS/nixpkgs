{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.28.2";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
    hash = "sha256-sLADYTjC2jXhKkZbq1ft61SDLjY6xpQjwlhS3XkitBo=";
  };

  vendorHash = "sha256-+N/aF/aDufOzejpsd49EtkAJGqPZd666KHL0khmS+OA=";

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}
  '';

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
