{ lib, stdenv, fetchurl, autoPatchelfHook }:

with lib;

let

  version = "1.3.4";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    x86_64-linux = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "1scs2msmg6ba91ri9al3299xnq8gq63clbqq1n03karf6ys2jnvi";
    };
    x86_64-darwin = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "0k3hfrcwa5sgg8mgmxp2xfykrshyp4bv77d3y8758zm7xqmmjg69";
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
