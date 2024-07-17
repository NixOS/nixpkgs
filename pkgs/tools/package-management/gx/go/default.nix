{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gx-go";
  version = "unstable-2020-03-03";

  src = fetchFromGitHub {
    owner = "whyrusleeping";
    repo = pname;
    rev = "9c30fadeac4aee8346d28c36d6bd5063da3d189a";
    hash = "sha256-lrfAyqAyRnhyw9dPURM1NeFIJW/Zug53ThZiwa89z2M=";
  };

  vendorHash = "sha256-A3jZYu7+LGCukzlrxgIPmnkcxSoWm5YJZmFG3hliMm4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A tool for importing go packages into gx";
    mainProgram = "gx-go";
    homepage = "https://github.com/whyrusleeping/gx-go";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
