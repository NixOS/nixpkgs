{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.33.8";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4QbIcg4C7TQJ1k+PQN0jwtZiXmcO8D609YkNLVyzW8w=";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
  };
}
