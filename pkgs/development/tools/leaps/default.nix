{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "leaps";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Jeffail";
    repo = "leaps";
    rev = "v${version}";
    sha256 = "sha256-9AYE8+K6B6/odwNR+UhTTqmJ1RD6HhKvtC3WibWUZic=";
  };

  vendorSha256 = "sha256-vEAOidGdygPnL5SzQB+hrJXSKB7tZw/jjpITroM4E/w=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A pair programming tool and library written in Golang";
    homepage = "https://github.com/jeffail/leaps/";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ qknight ];
    platforms = lib.platforms.unix;
  };
}
