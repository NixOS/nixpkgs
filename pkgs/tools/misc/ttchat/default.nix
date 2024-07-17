{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ttchat";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "atye";
    repo = "ttchat";
    rev = "v${version}";
    hash = "sha256-Ezlqji/j6nyCzc1jrfB1MZR4ugKAa5D5CL6wfuP6PsY=";
  };

  vendorHash = "sha256-6GcbEGC1O+lcTO+GsaVXOO69yIHMPywXJy7OFX15/eI=";

  meta = with lib; {
    description = "Connect to a Twitch channel's chat from your terminal";
    homepage = "https://github.com/atye/ttchat";
    license = licenses.asl20;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "ttchat";
  };
}
