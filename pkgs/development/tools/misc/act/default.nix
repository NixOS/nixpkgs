{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qx3vwsynmil1h3d2dzvqz0jzshfyy3vin14zjfmd353d915hf06";
  };

  modSha256 = "0276dngh29kzgm95d23r8ajjrrkss0v0f0wfq1ribgsxh17v0y5n";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
