{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-command";
  version = "0.9.0";
  rev = "v${version}";
  hash = "sha256-VnbtPhMyTZ4Oy+whOK6Itr2vqUagwZUODONL13fjMaU=";
  vendorHash = "sha256-MBWDEVA29uzHD3B/iPe68ntGjMM1SCTDq/TL+NgMc6c=";
  cmdGen = "pulumi-gen-command";
  cmdRes = "pulumi-resource-command";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/pkg/version.Version=v${version}"
  ];

  postConfigure = ''
    pushd ..

    ${cmdGen} provider/cmd/pulumi-resource-command/schema.json --version ${version}

    popd
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A Pulumi provider to execute commands and scripts either locally or remotely as part of the Pulumi resource model";
    homepage = "https://github.com/pulumi/pulumi-command";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
