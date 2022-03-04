{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rdap";
  version = "2019-10-17";
  vendorSha256 = "sha256-j7sE62NqbN8UrU1mM9WYGYu/tkqw56sNKQ125QQXAmo=";

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
    rev = "af93e7ef17b78dee3e346814731377d5ef7b89f3";
    sha256 = "sha256-7MR4izJommdvxDZSRxguwqJWu6KXw/X73RJxSmUD7oQ=";
  };

  doCheck = false;

  ldflags = [ "-s" "-w" "-X \"github.com/openrdap/rdap.version=OpenRDAP ${version}\"" ];

  meta = with lib; {
    homepage = "https://www.openrdap.org/";
    description = "Command line client for the Registration Data Access Protocol (RDAP)";
    license = licenses.mit;
    maintainers = with maintainers; [ sebastianblunt ];
  };
}
