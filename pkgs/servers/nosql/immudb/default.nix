{ lib
, buildGoModule
, fetchFromGitHub
, fetchzip
, installShellFiles
}:

let
  webconsoleVersion = "1.0.18";
  webconsoleDist = fetchzip {
    url = "https://github.com/codenotary/immudb-webconsole/releases/download/v${webconsoleVersion}/immudb-webconsole.tar.gz";
    sha256 = "sha256-4BhTK+gKO8HW1CelGa30THpfkqfqFthK+b7p9QWl4Pw=";
  };
in
buildGoModule rec {
  pname = "immudb";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "codenotary";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xvbks6dUiS14cntydAjSNTujxsSwYzmf+B4Zh4V/NwI=";
  };

  preBuild = ''
    mkdir -p webconsole/dist
    cp -r ${webconsoleDist}/* ./webconsole/dist
    go generate -tags webconsole ./webconsole
  '';

  vendorHash = "sha256-7mMutYx2/jmTx+7h9S412fYCFXiJnTGz0qwDSO7BIzM=";

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
