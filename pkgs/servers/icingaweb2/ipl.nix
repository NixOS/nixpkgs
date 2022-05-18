{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-ipl";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-library";
    rev = "v${version}";
    sha256 = "sha256:0ndd4gd26rglbz85izfvqc4ghcfa7wpq6ghrhggbzg819phndg5a";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "PHP library package for Icingaweb 2";
    homepage = "https://github.com/Icinga/icinga-php-library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
