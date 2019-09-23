{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "0.17.27";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    x86_64-linux = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "13ajgc8x5l3s93hmz6jg88if10bvd319jmkljy4n26zdp30vfqmw";
    };
    x86_64-darwin = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "0chpbnz2s4icwgmfq6kl8blz5mg4lpdqg061w3nh0p04adpgrn48";
    };
  };

in stdenv.mkDerivation {
  inherit version;
  pname = "pulumi";

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
