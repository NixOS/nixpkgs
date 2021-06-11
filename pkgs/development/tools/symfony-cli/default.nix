{ stdenvNoCC, fetchurl, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "symfony-cli";
  version = "4.25.2";

  src = fetchurl {
    url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_amd64.gz";
    sha256 = "8bfa53c1479883e9b48d2e4e5d3f6f7a511df73d65fe5c7b07a4890ee2c75c7e";
  };

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
    platforms = [ "x86_64-linux" ];
  };
}
