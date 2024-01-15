{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.19.3";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-Picdgy4CnMnKjENPfRvu0zLhykbH/uM0JfHh7cwDdoQ=";
  };

  vendorHash = "sha256-an43wSx5zhMirKAUnYv+5kDcUlv1fe1+mLGbBS7p4Qs=";

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
