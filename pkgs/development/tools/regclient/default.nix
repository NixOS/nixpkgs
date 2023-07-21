{ stdenv, lib, buildGoModule, fetchFromGitHub }:

let bins = [ "regbot" "regctl" "regsync" ]; in

buildGoModule rec {
  pname = "regclient";
  version = "0.5.0";
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "regclient";
    repo = "regclient";
    rev = tag;
    sha256 = "sha256-CkZh4wIxw4LdioOw48JQYgFkqK6A/gkAPuMNf5UpVXk=";
  };
  vendorHash = "sha256-55qJRYPdWyodMxkz9rLd/ukKkw9XXqe5CLcUP0Z8z8s=";

  outputs = [ "out" ] ++ bins;

  ldflags = [
    "-s"
    "-w"
    "-X main.VCSTag=${tag}"
  ];

  postInstall =
    lib.concatStringsSep "\n" (
      map (bin: ''
        mkdir -p ''$${bin}/bin &&
        mv $out/bin/${bin} ''$${bin}/bin/ &&
        ln -s ''$${bin}/bin/${bin} $out/bin/
      '') bins
    );

  meta = with lib; {
    description = "Docker and OCI Registry Client in Go and tooling using those libraries";
    homepage = "https://github.com/regclient/regclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
