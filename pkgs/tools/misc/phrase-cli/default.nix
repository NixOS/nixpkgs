{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-VE9HsNZJ6bPgqhWUpxf5/dC6giGaK3H9bawSs0S2SJ8=";
  };

  vendorSha256 = "sha256-1TXDGs3ByBX8UQWoiT7hFZpwbwFlDhHHU03zw4+Zml0=";

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
