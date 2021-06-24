{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wormhole-william";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "psanford";
    repo = "wormhole-william";
    rev = "v${version}";
    sha256 = "sha256-75pSFMzaZW+rtikO0khuxXIgb3Wj8ieSE4sB6quKgo4=";
  };

  vendorSha256 = "sha256-8GZ4h+DFQaCizOCxsMzAllXyaQgzQQBsbCnVi5MWbFg=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/psanford/wormhole-william";
    description = "End-to-end encrypted file transfers";
    changelog = "https://github.com/psanford/wormhole-william/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psanford ];
  };
}
