{ stdenvNoCC, fetchurl, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "symfony-cli";
  version = "4.26.8";

  src = fetchurl {
    url = "https://github.com/symfony/cli/releases/download/v${version}/symfony_linux_amd64.gz";
    sha256 = "sha256-/9jsdl39TOkuNCB4G7orJH4qR4Spdt7VTsC1jelyLs0=";
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
