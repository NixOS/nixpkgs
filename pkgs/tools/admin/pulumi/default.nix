{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "0.17.17";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    "x86_64-linux" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "1h1z8bngix1gvma3hahfyprrx3af5yncgvrsvr1cdsaa79bzvc5c";
    };
    "x86_64-darwin" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "0pipykwpqqnhqg28s27lnkbrm55rshf25ikil7ycwq05p9ynf5gq";
    };
  };

in stdenv.mkDerivation rec {
  inherit version;
  name = "pulumi-${version}";

  src = fetchurl pulumiArchPackage.${stdenv.hostPlatform.system};

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin/
  '';

  buildInputs = optionals stdenv.isLinux [ autoPatchelfHook ];

  meta = {
    homepage = https://pulumi.io/;
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    license = with licenses; [ asl20 ];
    platforms = builtins.attrNames pulumiArchPackage;
    maintainers = with maintainers; [
      peterromfeldhk
    ];
  };
}
