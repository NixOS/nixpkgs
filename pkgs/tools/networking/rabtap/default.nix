{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "rabtap";
  version = "1.43";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-OUpDk6nfVbz/KP7vZeZV2JfbCzh/KcuxG015/uxYuEI=";
  };

  vendorHash = "sha256-V7AkqmEbwuW2Ni9b00Zd22ugk9ScGWf5wauHcQwG7b0=";

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
