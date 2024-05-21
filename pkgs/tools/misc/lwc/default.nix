{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lwc";
  version = "unstable-2022-07-26";

  src = fetchFromGitHub {
    owner = "timdp";
    repo = "lwc";
    rev = "3330928c9d82200837350f85335f5e6c09f0658b";
    hash = "sha256-HFuXA5Y274XtgqG9odDAg9SSCgUxprnojfGavnYW4LE=";
  };

  vendorHash = "sha256-av736cW0bPsGQV+XFL/q6p/9VhjOeDwkiK5DLRnRtUg=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${src.rev}"
  ];

  meta = with lib; {
    description = "A live-updating version of the UNIX wc command";
    homepage = "https://github.com/timdp/lwc";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lwc";
  };
}
