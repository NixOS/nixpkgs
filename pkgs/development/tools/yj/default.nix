{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yj";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "sclevine";
    repo = "yj";
    rev = "v${version}";
    hash = "sha256-lsn5lxtix5W7po6nzvGcHmifbyhrtHgvaKYT7RPPCOg=";
  };

  vendorHash = "sha256-NeSOoL9wtFzq6ba8ghseB6D+Qq8Z5holQExcAUbtYrs=";

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "Convert YAML <=> TOML <=> JSON <=> HCL";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch ];
    homepage = "https://github.com/sclevine/yj";
  };
}
