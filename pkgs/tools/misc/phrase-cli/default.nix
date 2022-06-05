{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.4.10";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-dI11Y2sykEw1qsIpNJmzjyGbKcBw8rSx7etu7yE9peQ=";
  };

  vendorSha256 = "sha256-er8zQW1HT+xIi9l2AtI+LK2ijHUdBOyIYNzCsVx0a+Q=";

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
