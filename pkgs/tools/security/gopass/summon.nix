{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
<<<<<<< HEAD
  version = "1.15.7";
=======
  version = "1.15.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JoSNWgwTnFQbnrwGIk6L5SwQeNg0RfLMULceqFF/XnA=";
  };

  vendorHash = "sha256-gb9AZBh5oUAiuCXbsvkmYxcHRNd9KLYq35nMd4iabKw=";
=======
    hash = "sha256-ZAXdazhRqg9TbWWbftz9og3H7LTHenLlpFPIgZQHd/Q=";
  };

  vendorHash = "sha256-BXzXpG1Dy25IBf8EzgzOnFcbEvQGVhO8jgR/t6IKgPw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-summon-provider \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass Summon Provider";
<<<<<<< HEAD
    homepage = "https://github.com/gopasspw/gopass-summon-provider";
    changelog = "https://github.com/gopasspw/gopass-summon-provider/blob/v${version}/CHANGELOG.md";
=======
    homepage = "https://www.gopass.pw/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
