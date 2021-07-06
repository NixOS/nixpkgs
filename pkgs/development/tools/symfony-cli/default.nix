{ stdenvNoCC, fetchurl, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "symfony-cli";
  version = "4.25.4";

  src = fetchurl {
    url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_amd64.gz";
    sha256 = "94ade97d79e6949022ac45e4f8f9c025a9e3efa54a1a891a086a24eb9a9765a7";
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
