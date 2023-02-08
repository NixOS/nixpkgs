{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "phrase-cli";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "phrase";
    repo = "phrase-cli";
    rev = version;
    sha256 = "sha256-MX4na74T8+6As8e+izWz1O+xhNGfS2EKUT6goqy+sms=";
  };

  vendorHash = "sha256-Sfjp8EQeTlXayYSBO72KWLj+CScNUM5O49AP1qEfQTw=";

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
