{ stdenv, fetchurl }:

let

  version = "0.16.7";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    "x86_64-linux" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "1l1cn8pk05vl7vpmhny9rlz1hj0iqclqjj1r2q12qip7f4qkgsfw";
    };
    "x86_64-darwin" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "0p07jvgy0xl524fgb5d9wijxa91isv4h4mcn9qghycqj90yqnjhx";
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

  meta = with stdenv.lib; {
    homepage = https://pulumi.io/;
    description = "Pulumi is a cloud development platform that makes creating cloud programs easy and productive";
    license = with licenses; [ asl20 ];
    platforms = builtins.attrNames pulumiArchPackage;
    maintainers = with maintainers; [
      peterromfeldhk
    ];
  };
}
