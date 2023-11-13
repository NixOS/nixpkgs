{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "rabtap";
  version = "1.38.2";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-l35MHr7NWBlzKcGSDGjHTwGfnDrOpjeJp9/YAp1Areo=";
  };

  vendorHash = "sha256-sJFMef9VnU6iKGf9UwEK60axLUBkubFWgI+pWKjaWNU=";

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
