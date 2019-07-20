{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "goreman-${version}";
  version = "0.2.1";

  goPackagePath = "github.com/mattn/goreman";
  subPackages = ["."];

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "v${version}";
    sha256 = "1h7ip788j7bkygahpp7ylgnrx9jrbhwjzqpjhd1pflmlaxcbflcy";
  };

  meta = with lib; {
    description = "foreman clone written in go language";
    homepage = "https://github.com/mattn/goreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}

