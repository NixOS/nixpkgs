{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rdap";
  version = "0.9.1";
  vendorHash = "sha256-8b1EAnR8PkEAw9yLBqPKFeANJit0OCJG+fssAGR/iTk=";

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
    rev = "v${version}";
    sha256 = "sha256-FiaUyhiwKXZ3xnFPmdxb8bpbm5eRRFNDL3duOGDnc/A=";
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
