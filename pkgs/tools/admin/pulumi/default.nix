{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "1.4.0";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    x86_64-linux = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "00ywy2ba4xha6gwd42i3fdrk1myivkd1r6ijdr2vkianmg524k6f";
    };
    x86_64-darwin = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "02vqw9gn17dy3rfh0j00k9f827l42g3nl3rhlcbc8jbgx3n9c9qy";
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
