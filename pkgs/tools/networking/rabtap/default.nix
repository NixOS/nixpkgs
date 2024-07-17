{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "rabtap";
  version = "1.39.3";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-5SX6Ma8AMpm642vCGUR1HI6fkKBui16sf7Fm0IpPK6M=";
  };

  vendorHash = "sha256-wZOkQjSPMZW3+ohZb+MlBWNU3WTL4/lqggAOJLrYFHc=";

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
