{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "0.17.14";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    "x86_64-linux" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "0pqmmd0p000qax5y1z83h6k292yad0cm8i1s4kb4z2kddn0p9nnv";
    };
    "x86_64-darwin" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "0cgc41l8jf7raqqkdpn3yapvllmr43v17wly0rxqk47csh8905hd";
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
