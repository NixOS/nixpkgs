{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-cVTa2ot95Hcm+1V1QXnlxSL9OjmoQNR9nVUgW/rZhl0=";
  };

  vendorHash = "sha256-J4/a4ujM7A6bDwRlLCYt/PmJf6HZUmdYcJMux/3KyUI=";
=======
    sha256 = "sha256-Dc7MVn9hF2HtXqMvWQ5UsLQW5ZKcFKt7AHcXdiWDs1I=";
  };

  vendorHash = "sha256-hCdIO377LiXFKz0GfCmAADTPfoatk8YWzki7lVP3yLw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "Markdown defined task runner";
    homepage = "https://xcfile.dev/";
    changelog = "https://github.com/joerdav/xc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda joerdav ];
  };
}
