{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-command";
  version = "0.7.1";
  rev = "v${version}";
  hash = "sha256-QrKtnpJGWoc5WwV6bnERrN3iBJpyoFKFwlqBtNNK7F8=";
  vendorHash = "sha256-HyzWPRYfjdjGGBByCc8N91qWhX2QBJoQMpudHWrkmFM=";
  cmdGen = "pulumi-gen-command";
  cmdRes = "pulumi-resource-command";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/v4/pkg/version.Version=v${version}"
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
