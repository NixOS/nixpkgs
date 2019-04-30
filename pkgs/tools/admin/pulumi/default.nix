{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "0.17.4";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    "x86_64-linux" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "169hj0db3kcq8874sb3px1hk88ls08kq5w6wygay56whymhva65n";
    };
    "x86_64-darwin" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "1cn4mbgzq86d69mpp341zxfl8baakz0n5p9yd5chxrjjvxb6i629";
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
