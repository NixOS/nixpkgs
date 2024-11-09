{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-aws-native";
  version = "1.4.0";
  rev = "v${version}";
  hash = "sha256-MSsWK9eae1WEo/inNQ52T+B9c6XlJg2ycoFUOJhLJag=";
  vendorHash = "sha256-1IGahpX7hORFm8tZpoJGwdZWyihtnqR7QqVB5dYamxE=";
  cmdGen = "pulumi-gen-aws-native";
  cmdRes = "pulumi-resource-aws-native";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/pkg/version.Version=v${version}"
  ];

  fetchSubmodules = true;
  postConfigure = ''
    pushd ..

    chmod +w .
    chmod -R +w reports/

    ${cmdGen} --docs-url https://github.com/cdklabs/awscdk-service-spec/raw/main/sources/CloudFormationDocumentation/CloudFormationDocumentation.json docs ${version}
    ${cmdGen} --schema-folder aws-cloudformation-schema --metadata-folder meta schema ${version}

    popd
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Native AWS Pulumi Provider";
    mainProgram = "pulumi-resource-aws-native";
    homepage = "https://github.com/pulumi/pulumi-aws-native";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
