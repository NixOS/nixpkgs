{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-markdown-preview";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "yusukebe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WAKGtwz0CNqx86YOeLKWwfJiFcRAm1+X5kJOfsPgtjY=";
  };

  vendorSha256 = "sha256-O6Q9h5zcYAoKLjuzGu7f7UZY0Y5rL2INqFyJT2QZJ/E=";

  ldflags = [ "-s" "-w" "-X github.com/yusukebe/gh-markdown-preview/cmd.Version=${version}" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "gh extension to preview Markdown that looks like GitHub's";
    homepage = "https://github.com/yusukebe/gh-markdown-preview";
    changelog =
      "https://github.com/yusukebe/gh-markdown-preview/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misterio77 ];
  };
}
