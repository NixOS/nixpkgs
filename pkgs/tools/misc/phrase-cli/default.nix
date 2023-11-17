{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-/gNDuZ19uC7UjOFaPfNntQQ6H5e7VgxBHPD6eD4nSEM=";
  };

  vendorHash = "sha256-XBk4x3L6GJz1v6g46ODEOJN2J565O4IA8pOlhUD3bRE=";

  ldflags = [ "-X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=${version}" ];

  postInstall = ''
    ln -s $out/bin/phrase-cli $out/bin/phrase
  '';

  meta = with lib; {
    homepage = "http://docs.phraseapp.com";
    description = "PhraseApp API v2 Command Line Client";
    changelog = "https://github.com/phrase/phrase-cli/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
  };
}
