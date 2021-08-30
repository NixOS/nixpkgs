{ stdenvNoCC, fetchurl, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "symfony-cli";
  version = "4.25.5";

  src = fetchurl {
    url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_amd64.gz";
    sha256 = "sha256-DMyW2lKuoFVEguCQQ6efXrzvujL5H7PcgI0go98M0xI=";
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
