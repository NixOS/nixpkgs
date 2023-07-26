{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-b6Rh5TJHqcdexZ4AHY+4jQsCMdn69J3MTbmgKXEaACw=";
  };

  vendorHash = null;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    changelog = "https://github.com/ipinfo/cli/releases/tag/ipinfo-${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
