{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-azure-native";
  version = "2.69.0";
  rev = "v${version}";
  hash = "sha256-4kzLCBPHsSJHX7R4LOFYWoyQLdomihC6ppEnQQcdINE=";
  vendorHash = "sha256-JZNaez9jWQc2jMXTZywClb2/LAL1FuHLCJprV8MaFTk=";
  cmdGen = "pulumi-gen-azure-native";
  cmdRes = "pulumi-resource-azure-native";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/v2/provider/pkg/version.Version=${version}"
  ];
  cmdGenPostConfigure = ''
    pushd ..
    cp versions/v2-lock.json provider/pkg/versionLookup/
    popd
  '';
  postConfigure = ''
    pushd ..

    chmod +w . provider/cmd/${cmdRes} sdk/
    chmod -R +w reports/ versions/
    mkdir bin
    ${cmdGen} schema ${version}

    cp bin/schema-full.json provider/cmd/${cmdRes}
    cp bin/metadata-compact.json provider/cmd/${cmdRes}
    cp versions/v2-lock.json provider/pkg/versionLookup/

    popd

    VERSION=v${version} go generate cmd/${cmdRes}/main.go
  '';
  fetchSubmodules = true;
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "Native Azure Pulumi Provider";
    mainProgram = "pulumi-resource-azure-native";
    homepage = "https://github.com/pulumi/pulumi-azure-native";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
