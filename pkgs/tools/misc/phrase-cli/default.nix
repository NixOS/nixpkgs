{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "0xlfcj0jd6x4ynzg6d0p3wlmfq660w3zm13nzx04jfcjnks9sqvl";
  };

  vendorSha256 = "1ablrs3prw011bpad8vn87y3c81q44mps873nhj278hlkz6im34g";

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
