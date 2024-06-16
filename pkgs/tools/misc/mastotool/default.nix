{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mastotool";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "mastotool";
    rev = "v${version}";
    hash = "sha256-KmYUt2WXLY6i17dZ+o5HOTyMwbQnynY7IT43LIEN3B0=";
  };

  vendorHash = "sha256-uQgLwH8Z8rBfyKHMm2JHO+H1gsHK25+c34bOnMcmquA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A collection of command-line tools to work with your Mastodon account";
    homepage = "https://github.com/muesli/mastotool";
    changelog = "https://github.com/muesli/mastotool/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "mastotool";
  };
}
