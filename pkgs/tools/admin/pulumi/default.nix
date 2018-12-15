{ stdenv, fetchurl }:

let

  version = "0.16.2";

  # switch the dropdown to “manual” on https://pulumi.io/quickstart/install.html # TODO: update script
  pulumiArchPackage = {
    "x86_64-linux" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-linux-x64.tar.gz";
      sha256 = "16qgy2pj3xkf1adi3882fpsl99jwsm19111fi5vzh1xqf39sg549";
    };
    "x86_64-darwin" = {
      url = "https://get.pulumi.com/releases/sdk/pulumi-v${version}-darwin-x64.tar.gz";
      sha256 = "18ck9khspa0x798bdlwk8dzylbsq7s35xmla8yasd9qqlab1yy1a";
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
