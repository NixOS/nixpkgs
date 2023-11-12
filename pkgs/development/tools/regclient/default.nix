{ stdenv, lib, buildGoModule, fetchFromGitHub }:

let bins = [ "regbot" "regctl" "regsync" ]; in

buildGoModule rec {
  pname = "regclient";
  version = "0.5.4";
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "regclient";
    repo = "regclient";
    rev = tag;
    sha256 = "sha256-xjyzGrcr3yVny70P5BvV9meshOcvbf6BWhuBE1PlK4Q=";
  };
  vendorHash = "sha256-JIvFHaq9RCqDurKTnoT9/yJevHotuG22AyizTMLtHPc=";

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
