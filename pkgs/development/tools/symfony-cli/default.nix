{ stdenvNoCC, fetchurl, lib }:

let
  version = "4.26.9";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_amd64.gz";
      sha256 = "0ivqqrpzbpyzp60bv25scarmvisj401rp7h2s3cxa7d17prja91v";
    };

    i686-linux = fetchurl {
      url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_386.gz";
      sha256 = "0ag5w70bkvj9wgp4yzzy824shj907sa5l20sqcgivi3r5gy0p277";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_arm64.gz";
      sha256 = "00325xz7xl3bprj5zbg5yhn36jf4n37zlyag10m8zcmq8asa6k51";
    };

    x86_64-darwin = fetchurl {
        url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_darwin_amd64.gz";
        sha256 = "00325xz7xl3bprj5zbg5yhn36jf4n37zlyag10m8zcmq8asa6k51";
      };
  };
in stdenvNoCC.mkDerivation rec {
  inherit version;
  pname = "symfony-cli";

  src = srcs.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  dontBuild = true;

  unpackPhase = ''
    gunzip <$src >symfony
  '';

  installPhase = ''
    install -D -t $out/bin symfony
  '';

  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://symfony.com/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ drupol ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" ];
  };
}
