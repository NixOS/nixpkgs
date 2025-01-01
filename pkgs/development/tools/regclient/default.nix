{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, lndir
, testers
, regclient
}:

let bins = [ "regbot" "regctl" "regsync" ]; in

buildGoModule rec {
  pname = "regclient";
  version = "0.7.1";
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "regclient";
    repo = "regclient";
    rev = tag;
    sha256 = "sha256-QG0qwilYqsueyI3rzpNj9z8gYYRzIorlOID+baORgJU=";
  };
  vendorHash = "sha256-gqnE3kfBLjV8CroYcJwa9QWCFOL/dBIblPQJZR2DW+4=";

  outputs = [ "out" ] ++ bins;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/regclient/regclient/internal/version.vcsTag=${tag}"
  ];

  nativeBuildInputs = [ installShellFiles lndir ];

  postInstall = lib.concatMapStringsSep "\n"
    (bin: ''
      export bin=''$${bin}
      export outputBin=bin

      mkdir -p $bin/bin
      mv $out/bin/${bin} $bin/bin

      installShellCompletion --cmd ${bin} \
        --bash <($bin/bin/${bin} completion bash) \
        --fish <($bin/bin/${bin} completion fish) \
        --zsh <($bin/bin/${bin} completion zsh)

      lndir -silent $bin $out

      unset bin outputBin
    '')
    bins;

  checkFlags = [
    # touches network
    "-skip=^ExampleNew$"
  ];

  passthru.tests = lib.mergeAttrsList (
    map
      (bin: {
        "${bin}Version" = testers.testVersion {
          package = regclient;
          command = "${bin} version";
          version = tag;
        };
      })
      bins
  );

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Docker and OCI Registry Client in Go and tooling using those libraries";
    homepage = "https://github.com/regclient/regclient";
    license = licenses.asl20;
    maintainers = with maintainers; [ maxbrunet ];
  };
}
