{ lib
, fetchFromGitHub
, buildGoModule
, gh-markdown-preview
, testers
}:

buildGoModule rec {
  pname = "gh-markdown-preview";
<<<<<<< HEAD
  version = "1.4.2";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yusukebe";
    repo = "gh-markdown-preview";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UBveXL4/3GxxIVjqG0GuTbkGkzXFc/stew2s+dTj9BI=";
=======
    hash = "sha256-WAKGtwz0CNqx86YOeLKWwfJiFcRAm1+X5kJOfsPgtjY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-O6Q9h5zcYAoKLjuzGu7f7UZY0Y5rL2INqFyJT2QZJ/E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/yusukebe/gh-markdown-preview/cmd.Version=${version}"
  ];

  # Tests need network
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion { package = gh-markdown-preview; };
  };

  meta = {
    description = "gh extension to preview Markdown looking like on GitHub";
    homepage = "https://github.com/yusukebe/gh-markdown-preview";
    changelog = "https://github.com/yusukebe/gh-markdown-preview/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
