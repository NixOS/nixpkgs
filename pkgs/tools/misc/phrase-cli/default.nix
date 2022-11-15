{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-4+PS85cZZR8lKjBTtWC72P713dYO+8IDZbiTNKY/YDA=";
  };

  vendorSha256 = "sha256-LlMBV52CG1uYW7I/e0VwoIIr0wk3ysc5gqrAlFRPsvE=";

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
