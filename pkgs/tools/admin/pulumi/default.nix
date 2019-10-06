{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "1.1.0";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    x86_64-linux = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "1r498pxsjdj9mhdzh9vh4nw8fcjxfga44xlg43b0yakkgrp7c224";
    };
    x86_64-darwin = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "02nr5yxn5aqgbwrnl4shgd6rh4n4v8giqki4qkbgx74xf3bbwihg";
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
