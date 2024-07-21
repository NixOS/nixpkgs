{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-actions-cache";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "gh-actions-cache";
    rev = "v${version}";
    hash = "sha256-GVha3xxLTBTiKfAjGb2q9btsGYzWQivGLyZ4Gg0s/N0=";
  };

  vendorHash = "sha256-4/Zt+ga3abEPtR0FjWIsDpOiG1bfVtVuLuXP8aHbzqk=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Needed for tests.
  # https://github.com/actions/gh-actions-cache/issues/53#issuecomment-1464954495
  env.GH_TOKEN = "dummy-token-to-facilitate-rest-client";

  meta = {
    description = "gh extension to manage GitHub Actions caches";
    homepage = "https://github.com/actions/gh-actions-cache";
    changelog = "https://github.com/actions/gh-actions-cache/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-actions-cache";
  };
}
