{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-ipl";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-library";
    rev = "v${version}";
    hash = "sha256-3Vf3jT+/jh1YxJrnOFuGkhNIOyioZavSAHMmmkgA2gg=";
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
