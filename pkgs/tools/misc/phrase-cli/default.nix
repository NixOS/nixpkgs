{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
<<<<<<< HEAD
  version = "2.11.0";
=======
  version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-8LhXsrO0sXMu7cXNoLafwNgCO99zGcQBYcCmqJfM2KY=";
  };

  vendorHash = "sha256-lbJetTERQKnDKmM1VqRWU0OjZPm+bfeQ9ZThs/TzxIU=";
=======
    sha256 = "sha256-Gima27E77iJEgOVY49Y2s9kQkd+rnzS359ru5NAyGik=";
  };

  vendorHash = "sha256-a0QA/1vUryAnO0Nr+m8frxtpnSHBOSOP1pq+BORTIJw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=${version}" ];

  postInstall = ''
    ln -s $out/bin/phrase-cli $out/bin/phrase
  '';

  meta = with lib; {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
  };
}
