{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "7.93.1";

  src = fetchFromGitHub {
    owner = "JanDeDobbeleer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sldYhha1FD4IJnOE/4gjFW66zzC0NRUADjxg2otkJMg=";
  };

  modRoot = "src/";

  vendorSha256 = "sha256-trG+w+xUlfsBkMfkM7vRxO41vXdymPFp5IYILR7hlQc=";

  meta = with lib; {
    description = "A prompt theme engine for any shell.";
    homepage = "https://ohmyposh.dev";
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "oh-my-posh";
  };
}
