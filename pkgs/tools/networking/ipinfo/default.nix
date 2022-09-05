{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "${pname}-${version}";
    hash = "sha256-j+ASyNWfYh4/u7OX3iZx8DZZg1XAwuy6fpC9TJKI+18=";
  };

  vendorSha256 = null;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
