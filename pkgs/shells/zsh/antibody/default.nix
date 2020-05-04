{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "0m7c879b3f402av20jsybq2dhhckbknlvn2n1csp7xmcz4zcyn1n";
  };

  modSha256 = "0yny1p8vll1wdqdlwyxf9m4kd5njdm7nq527blqqa680zf2k4h8b";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = "https://github.com/getantibody/antibody";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 worldofpeace ];
  };
}
