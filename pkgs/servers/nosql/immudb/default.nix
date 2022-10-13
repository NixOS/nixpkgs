{ lib
, buildGoModule
, fetchFromGitHub
, fetchzip
, installShellFiles
}:

let
  webconsoleVersion = "1.0.17";
  webconsoleDist = fetchzip {
    url = "https://github.com/codenotary/immudb-webconsole/releases/download/v${webconsoleVersion}/immudb-webconsole.tar.gz";
    sha256 = "sha256-hFSvPwSRXyrSBYktTOwIRa1+aH+mX/scDYDokvZuW1s=";
  };
in
buildGoModule rec {
  pname = "immudb";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "codenotary";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L8RvbMmq9DPJ2FvxlCE1KC8TRhmZA5CrzUPmr9JNy0Q=";
  };

  preBuild = ''
    mkdir -p webconsole/dist
    cp -r ${webconsoleDist}/* ./webconsole/dist
    go generate -tags webconsole ./webconsole
  '';

  proxyVendor = true; # check if this is needed anymore when updating

  vendorSha256 = "sha256-+k2oH3qs9rLLh1rfxfTCAv3UyWnmaX6pVhYXV20F0lY=";

  nativeBuildInputs = [ installShellFiles ];

  tags = [ "webconsole" ];

  ldflags = [ "-X github.com/codenotary/immudb/cmd/version.Version=${version}" ];

  subPackages = [
    "cmd/immudb"
    "cmd/immuclient"
    "cmd/immuadmin"
  ];

  postInstall = ''
    mkdir -p share/completions
    for executable in immudb immuclient immuadmin; do
      for shell in bash fish zsh; do
        $out/bin/$executable completion $shell > share/completions/$executable.$shell
        installShellCompletion share/completions/$executable.$shell
      done
    done
  '';

  meta = with lib; {
    description = "Immutable database based on zero trust, SQL and Key-Value, tamperproof, data change history";
    homepage = "https://github.com/codenotary/immudb";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
